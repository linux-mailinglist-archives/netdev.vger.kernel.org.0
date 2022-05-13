Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D182525A10
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376740AbiEMDZs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 May 2022 23:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376737AbiEMDZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:25:46 -0400
Received: from spamcs.greatwall.com.cn (mail.greatwall.com.cn [111.48.58.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C25D6FF5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 20:25:41 -0700 (PDT)
X-ASG-Debug-ID: 1652412958-0ec56f200547ac0001-BZBGGp
Received: from greatwall.com.cn (mailcs.greatwall.com.cn [10.47.36.11]) by spamcs.greatwall.com.cn with ESMTP id rLvCVdMsnQhy287p for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:35:58 +0800 (CST)
X-Barracuda-Envelope-From: lianglixue@greatwall.com.cn
X-Barracuda-RBL-Trusted-Forwarder: 10.47.36.11
Received: from smtpclient.apple (unknown [223.104.68.21])
        by mailcs.greatwall.com.cn (Coremail) with SMTP id CyQvCgD3du76zX1iYGUsAA--.47503S2;
        Fri, 13 May 2022 11:18:19 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
X-Barracuda-RBL-IP: 223.104.68.21
X-Barracuda-Effective-Source-IP: UNKNOWN[223.104.68.21]
X-Barracuda-Apparent-Source-IP: 223.104.68.21
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixue@greatwall.com.cn>
X-ASG-Orig-Subj: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
In-Reply-To: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
Date:   Fri, 13 May 2022 11:25:07 +0800
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C59C9B62-3B78-433B-B40E-9869043333E1@greatwall.com.cn>
References: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
 <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: CyQvCgD3du76zX1iYGUsAA--.47503S2
X-Coremail-Antispam: 1UD129KBjvdXoWrGw4rZFykCrWUZw4fJr1rCrg_yoWxGFg_C3
        4Fy397JryDuas2gr4v93ZxJryfWrWktry8Z34DJr45ta4YyFs5Jr4kGa40qw1Yqa4vqrnr
        tr1xJ342krnxKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbF8YjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2Iq
        xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
        106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
        xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7
        xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_
        GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8pnQUUUUUU==
X-CM-SenderInfo: xold0w5ol03v46juvthwzdzzoofrzhdfq/
X-Barracuda-Connect: mailcs.greatwall.com.cn[10.47.36.11]
X-Barracuda-Start-Time: 1652412958
X-Barracuda-URL: https://10.47.36.10:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at greatwall.com.cn
X-Barracuda-Scan-Msg-Size: 646
X-Barracuda-Bayes: INNOCENT GLOBAL 0.6335 1.0000 0.9222
X-Barracuda-Spam-Score: 0.92
X-Barracuda-Spam-Status: No, SCORE=0.92 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.97972
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paul,

Thank you so much for taking so much time to provide guidance,
I've fixed the other two issues, but the "Reported by" tag issue I don’t quite understand.


> 2022年5月12日 21:55，Paul Menzel <pmenzel@molgen.mpg.de> 写道：
> 
>> Reported-by: kernel test robot <lkp@intel.com>
> 
> This line is confusing. Maybe add that to the version change-log below the `—`

I add it in the form of cmmit message. I understand that you mean to add 
"Reported by" under '---‘, but I don't know how to add it. Please give me 
further guidance. I'm so sorry to trouble you.Sincerely waiting for your response.

Thank you!
