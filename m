Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3D05362A7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 14:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiE0MiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 08:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244530AbiE0MiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 08:38:03 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D3F1A8E21;
        Fri, 27 May 2022 05:20:59 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s14so3995785plk.8;
        Fri, 27 May 2022 05:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=iJRtC6FZ8/ulUwIgZS39WaHh+o9Ilrp1wW7JFepItc0=;
        b=qSLrw/xH/l+UVkirRAZz/8FZ0ZZjL5uSuxHX7LIvFmTyb2UbiCPcMLJ7FPei3UtAUG
         /ngnpOH2XTctk2kEZnq1GlxnsaUo07pYEaINTbsCgqrOHFJQt24gZQ+ILHVpJtEzyjME
         4UrYxkBjVTiElekXp+gzuW+XAGU6/RtkFdOXe+8dCI4p/cXb8vCquU8DfILasd9urWSo
         KHl1WoMhA+RFZrgD0SzbVWJBhfTAXtdoOWgI9FuBo/sPpuLmHrpwM/ULSW9MXKoel/hj
         SOkK23tv+gEHbYe80ZKZG6/zw7Y4B7GfXZTNIaeke82Up93gcA/IDSi6cSpXHo/eaf+S
         8+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=iJRtC6FZ8/ulUwIgZS39WaHh+o9Ilrp1wW7JFepItc0=;
        b=IadmFGgIBN5MiOuyC90KPCx7/qMyYhSEPcE7+u2jVfyPyYS3b32xJ/DtgLYnpqyBhL
         YOJwsGcQ+bi/pT3hptDW7HCRdS52SeM1J0OKI4NCDz7JZhfrCXauGqmE0c7Qy3ksG3g5
         GcdGTfPUq4gsfxpVpDo+9tMyZVzvZ6bH6EhZgplvV/B/mH1l+Cg1Q5pGA+ClevVacl4b
         r1Ap/vD7Csw9kKsst8U40kOlYOZb59ciTEQr+ra5KeR6o7z1CQvPhBrCChKwQE51FvvW
         fHeKk3tj+vI/+rqzKs68c4fE0w/zSO3+SlYJanBCYbmXgRNcgE316MUpfqJutsVvNmlJ
         rruA==
X-Gm-Message-State: AOAM532neNjBGPbbwBT1Tn4oVcnf/E6ynMWF14+VNqBovPIrVPA1xMJA
        5rFc8Jz7F82eoREgWNfbnpU=
X-Google-Smtp-Source: ABdhPJyhM4+yaDnivdy5jmDUaKkUnBpSnlKSW9KCRZAyRvH55Ju8bIw6KCyC4TQtzI1iKBxbIA25WA==
X-Received: by 2002:a17:903:2305:b0:163:64c7:f9ff with SMTP id d5-20020a170903230500b0016364c7f9ffmr11636415plh.46.1653654059447;
        Fri, 27 May 2022 05:20:59 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::597? ([2404:f801:9000:18:efec::597])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b0015ea8b4b8f3sm3463974plg.263.2022.05.27.05.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 05:20:58 -0700 (PDT)
Message-ID: <56243d2b-d7f6-9e45-d5fd-3af7767d52e3@gmail.com>
Date:   Fri, 27 May 2022 20:20:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Reply-To: tiala@microsoft.com
Subject: Re: [RFC PATCH V3 2/2] net: netvsc: Allocate per-device swiotlb
 bounce buffer for netvsc
Content-Language: en-US
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "andi.kleen@intel.com" <andi.kleen@intel.com>,
        "kirill.shutemov" <kirill.shutemov@intel.com>
References: <20220526120113.971512-1-ltykernel@gmail.com>
 <20220526120113.971512-3-ltykernel@gmail.com>
 <BYAPR21MB12706372826A3ABAEF42E716BFD99@BYAPR21MB1270.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Organization: Microsft
In-Reply-To: <BYAPR21MB12706372826A3ABAEF42E716BFD99@BYAPR21MB1270.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2022 2:43 AM, Dexuan Cui wrote:
>> From: Tianyu Lan <ltykernel@gmail.com>
>> Sent: Thursday, May 26, 2022 5:01 AM
>> ...
>> @@ -119,6 +124,10 @@ static void netvsc_subchan_work(struct work_struct
>> *w)
>>   			nvdev->max_chn = 1;
>>   			nvdev->num_chn = 1;
>>   		}
>> +
>> +		/* Allocate boucne buffer.*/
>> +		swiotlb_device_allocate(&hdev->device, nvdev->num_chn,
>> +				10 * IO_TLB_BLOCK_UNIT);
>>   	}
> 
> Looks like swiotlb_device_allocate() is not called if the netvsc device
> has only 1 primary channel and no sub-schannel, e.g. in the case of
> single-vCPU VM?

When there is only sinlge，there seems not to be much performance
penalty. But you are right, we should keep the same behavior when single 
CPU and multi CPU. Will update in the next version.

Thanks.

