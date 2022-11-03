Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C03617F7A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiKCO1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiKCO1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:27:41 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF71F1705F;
        Thu,  3 Nov 2022 07:27:40 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y13so1753543pfp.7;
        Thu, 03 Nov 2022 07:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIuosJEuTIxTU4vgxtOOKlEeHtCDZ/WY4hzhdvsVb58=;
        b=Ba26o1h0RwuZQrcVdQXGiWeePY+jTdQIWBBQKuQzaN7V42GxlZj2i1fdP1awb5nRYi
         I+XlmteiHLFtd+YYOFakh8deA+ZTwe2sijmvTewpGEHDXDgiBdwKoZO8LVgkGNlkjUQg
         ejex1GdrLJHlvKCDujXrlOUJYkLPMXbUlQ9kTKFZY3xU2PYafUzIzitV6KUUNFvgkb99
         rcUp7UGzwyyAO2CAjupw4+6fZeuJTIOT2pe6EX1nDLTtAA2nMBUtjeOy7FAtVDtHUPbk
         AJlpy/v/2QXPCaDVK9fBaIvova8EoGRWFJspfPqLri0gnzTKjruMX+Y7mYIzhiWKankj
         9oMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIuosJEuTIxTU4vgxtOOKlEeHtCDZ/WY4hzhdvsVb58=;
        b=2K0yo5aI9rGnVi28nYdWHN+5AdYUv5LSH1kFHLj1IJTM5tzE3V93YoU7i/FD9VDqvr
         p2+iDiZ4LazMF2n30J+xEbceCKBkWtxQxquNF2A6QRYXyicDEvyxfT/L88Y5yOfmt/Nx
         CToBwJ90pU7euETfIzP1AUh4LqIvsJP+GI/zKFJ/YGPtvVB+9sV80esVCaAfe7HSWxMP
         jhuAl84etXoL2jZMuHdXADWac0wPEXhSzpcAhb25UUqnH6hvw88hn+byTaZno2KjmfnQ
         YMGGSjmf6NiXCwxNCHtgmrq4dDp3P6sLxqOiE9mfG4EmZBz6odjC3cPl88IlrVeWrWDm
         auPQ==
X-Gm-Message-State: ACrzQf3alWIEHmyN13Q9o6zaTgUlsIVbWtaafcgkwFryX93AH482DqSz
        5udLdxgK/WEriVbzIW3X6S4=
X-Google-Smtp-Source: AMsMyM5wdqSY1H/m6g6FYCRAGcDeMB7vyoR6fpb0bzRrRGYER7iaHfadrE7m+/r3x3fwIfKhXP6/BQ==
X-Received: by 2002:a63:f964:0:b0:46f:e243:fd8e with SMTP id q36-20020a63f964000000b0046fe243fd8emr13936135pgk.207.1667485660470;
        Thu, 03 Nov 2022 07:27:40 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:18:efec::75b])
        by smtp.gmail.com with ESMTPSA id n184-20020a6227c1000000b0056b9df2a15esm825190pfn.62.2022.11.03.07.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:27:39 -0700 (PDT)
Message-ID: <f295f2f4-b7c7-0faf-cc99-9a052a7bf7ef@gmail.com>
Date:   Thu, 3 Nov 2022 22:27:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 07/12] Drivers: hv: vmbus: Remove second mapping of VMBus
 monitor pages
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
 <1666288635-72591-8-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-8-git-send-email-mikelley@microsoft.com>
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
> mapping for VMBus monitor pages. Because set_memory_decrypted()
> and set_memory_encrypted() are no-ops in normal VMs, it's
> not even necessary to test for being in a Confidential VM
> (a.k.a., "Isolation VM").
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
