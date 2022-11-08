Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8784E620D7A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiKHKhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbiKHKhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:37:13 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67584298A;
        Tue,  8 Nov 2022 02:36:54 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b21so13790400plc.9;
        Tue, 08 Nov 2022 02:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7FC4xTWKbEcJxVm+LBMuB4SUqqHDVOvyFDbcq+yh01A=;
        b=oCWmwDp8Mq/94lPgWOpRNMqusVjIbpZKRV9JeuSrdvQOJhGpRXChOO08QAlKk8Wx73
         s9dECqgOGqSg/8HsqRHiP/XKfZq37XO9aPQHjT6sIVfwd2T5rgHuMt0YXR0vcVnuqJPC
         bYyXpc+YB5DY79XuJsgDgEnii3hXBb2hLVOouhQABdDKDpptyrIasT3qltTbts8XnJrU
         VZTd4OMKS0clmozmVyOJgYGhRCfkJh6l8h11/FOcCQ+LBk3+XZqX0RE3+w4sLEria5R3
         Qsi/EmUKkAqx8Cc/Ujp41/7pVyFg5TMnjalYEafM8z3HSH10qmw+8OMIN07CWneo6bGA
         xdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FC4xTWKbEcJxVm+LBMuB4SUqqHDVOvyFDbcq+yh01A=;
        b=pJruh9JrSZeI3RPG9Djmph6xka+bXU3ieDTszK6HR9tUalxsckaWfe08+qq/ThY7rW
         Dgewo09gIoPDObpiqAtXZhN2EgNx+1VonZrwd/pAerJyVAtoSHIrmRiuUm7cUxv4+3si
         Xd0hmEPByQzYXjfY7w1Gtg5wjyPtNxjyYcZ8YFgVzxpFO0cBm1kfK89TBu1DuhSvJmZb
         VtB6uWqwaH7crvvfBMxc/1nPnTKJevXXzkSqreEBafOcIPr4UOsyx0S5q0jdmG5/jtaN
         ozoUjZw6xqpKbEr7shyIbsY6KvqXtGAQckvg+Ndxpz2vqfnaux544xZgacm9+4FCDE2d
         JkXw==
X-Gm-Message-State: ACrzQf1TXcmCs2LcDd1iFpoNzqc69NWs4kFVc/HKVMl8bS+vqP6KLIXm
        /xXpd//U0QrwDdyNGJN01qQ=
X-Google-Smtp-Source: AMsMyM4t0UZsTKGoBIe7o5gVWR0wgRXPrt+fajdjHMMuWw0RmjuTkgxkIK95E7qPspPcKE7d1giP0A==
X-Received: by 2002:a17:90b:254c:b0:20a:8a92:ea5b with SMTP id nw12-20020a17090b254c00b0020a8a92ea5bmr56165515pjb.81.1667903814151;
        Tue, 08 Nov 2022 02:36:54 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:1a:efea::75b])
        by smtp.gmail.com with ESMTPSA id h5-20020a17090a648500b0020a11217682sm5700073pjj.27.2022.11.08.02.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 02:36:53 -0800 (PST)
Message-ID: <9a4edf34-6e49-9fd0-fc23-2536c5f087ea@gmail.com>
Date:   Tue, 8 Nov 2022 18:36:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 09/12] hv_netvsc: Remove second mapping of send and recv
 buffers
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-10-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-10-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2022 1:57 AM, Michael Kelley wrote:
> With changes to how Hyper-V guest VMs flip memory between private
> (encrypted) and shared (decrypted), creating a second kernel virtual
> mapping for shared memory is no longer necessary.  Everything needed
> for the transition to shared is handled by set_memory_decrypted().
> 
> As such, remove the code to create and manage the second
> mapping for the pre-allocated send and recv buffers.  This mapping
> is the last user of hv_map_memory()/hv_unmap_memory(), so delete
> these functions as well.  Finally, hv_map_memory() is the last
> user of vmap_pfn() in Hyper-V guest code, so remove the Kconfig
> selection of VMAP_PFN.
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
