Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91570525A5E
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376882AbiEMDsH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 May 2022 23:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376758AbiEMDsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:48:03 -0400
Received: from spamsz.greatwall.com.cn (spamfw.greatwall.com.cn [111.48.58.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3FAB5FF01
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 20:48:00 -0700 (PDT)
X-ASG-Debug-ID: 1652413678-0ec57242fe11fa0001-BZBGGp
Received: from greatwall.com.cn (mailsz.greatwall.com.cn [10.46.20.97]) by spamsz.greatwall.com.cn with ESMTP id OWopBpAiFrT4lzIJ for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:47:58 +0800 (CST)
X-Barracuda-Envelope-From: lianglixue@greatwall.com.cn
X-Barracuda-RBL-Trusted-Forwarder: 10.46.20.97
Received: from smtpclient.apple (unknown [223.104.68.8])
        by mailsz.greatwall.com.cn (Coremail) with SMTP id YRQuCgCnBFJZ031iULQUAA--.33972S2;
        Fri, 13 May 2022 11:41:14 +0800 (CST)
Content-Type: text/plain;
        charset=utf-8
X-Barracuda-RBL-IP: 223.104.68.8
X-Barracuda-Effective-Source-IP: UNKNOWN[223.104.68.8]
X-Barracuda-Apparent-Source-IP: 223.104.68.8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
From:   =?utf-8?B?5qKB56S85a2m?= <lianglixue@greatwall.com.cn>
X-ASG-Orig-Subj: Re: [Intel-wired-lan] [PATCH v2 2/2] igb_main: Assign random MAC
 address instead of fail in case of invalid one
In-Reply-To: <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
Date:   Fri, 13 May 2022 11:47:56 +0800
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com, Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, Netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2F78D699-8D54-4E3B-9D1E-DD869715D67F@greatwall.com.cn>
References: <20220512093918.86084-1-lianglixue@greatwall.com.cn>
 <d50b23b1-38b5-2522-cbf4-c360c0ed05cd@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-CM-TRANSID: YRQuCgCnBFJZ031iULQUAA--.33972S2
X-Coremail-Antispam: 1UD129KBjvJXoWruF4DCFy3Ww17Jr1rKw43GFg_yoW8Jry8pF
        s5WanFkryDGwsFyaykXr1IvFyru39Yg3Z8Gr9xtr1fuwnI9rW29ry8KrnxtF98Z3s7G3yj
        yw4UArs5Za15JaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyab7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4
        vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
        v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
        67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2
        IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
        Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8pnQUUUUUU==
X-CM-SenderInfo: xold0w5ol03v46juvthwzdzzoofrzhdfq/
X-Barracuda-Connect: mailsz.greatwall.com.cn[10.46.20.97]
X-Barracuda-Start-Time: 1652413678
X-Barracuda-URL: https://spamfw.greatwall.com.cn:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at greatwall.com.cn
X-Barracuda-Scan-Msg-Size: 1299
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5073 1.0000 0.7500
X-Barracuda-Spam-Score: 0.75
X-Barracuda-Spam-Status: No, SCORE=0.75 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
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
> Dear Lixue,
> 
> 
> Thank you for sending version 2. Some more minor nits.
> 
> Am 12.05.22 um 11:39 schrieb lixue liang:
>> In some cases, when the user uses igb_set_eeprom to modify the MAC
>> address to be invalid, the igb driver will fail to load. If there is no
>> network card device, the user must modify it to a valid MAC address by
>> other means.
>> Since the MAC address can be modified ,then add a random valid MAC address
>> to replace the invalid MAC address in the driver can be workable, it can
>> continue to finish the loading ,and output the relevant log reminder.
> 
> Please add the space after the comma.
> 
>> Reported-by: kernel test robot <lkp@intel.com>
> 
> This line is confusing. Maybe add that to the version change-log below the `---`.
> 

I add it in the form of cmmit message. I understand that you mean to add 
"Reported by" under '---‘, but I don't know how to add it. Please give me 
further guidance. I'm so sorry to trouble you.Sincerely waiting for your response.

Thank you!

