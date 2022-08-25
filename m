Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6A5A09B0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiHYHMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237659AbiHYHLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:11:45 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2215B07B;
        Thu, 25 Aug 2022 00:11:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 2so17794917pll.0;
        Thu, 25 Aug 2022 00:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=oTpPF3Aix7VclJ3dXzlNmbBjMMwsnWz3DKrKPEfxiQs=;
        b=Qf7OX+zLG/7Oqll9BK+bZUXamvgC85QN4W56Sz0Ea2fYSXcQgziGp2AZ+Z7BUe/p1c
         kV+dsA365zeJDhVdFrpEvJUDe7kIK58TEUh8nIwrSxssURRv9/h+ZaJ/tpYEboFFyYpH
         iD65XWOeU+xLw7RNA9fpwEhBKh2c1QGgYTKTwzw/haxEuzpLouVKekcqY11B3390kanD
         SqdfULKZ9+jX6dZH3IEVyExO4PVuhS2zIzGKno5YnWSwqlcJ3wtLArJJJksH9rT1VmzE
         2586/H49VTSIosSwlO/1RGm1I3asDeHCtHo+GOJUr6Z3lBK/6j0CzwVeZWvwqZx5WIwx
         doZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=oTpPF3Aix7VclJ3dXzlNmbBjMMwsnWz3DKrKPEfxiQs=;
        b=wrsafaPmbPv23IkZwFW8hcbCNhozehcshFe8IG0k1Bm4Qa3HBTCXSH/VLlj40w4+YA
         s+RbZd3J8Y22isIVC7UCsD87xxp9AKoz2ej71TZR/UuxQndrQsq9D/YTFOTFw3ANTd16
         sSOCadAHwUqcuLsC5cUSry6yiFynchPBW8ckhlnIeP7PHVOR9jbPToj9KDmsgrtyXBoP
         p2vaQSSNj6kDzGJ7ppA0FUwVTm4Laqx+Z2QokLHEklyWMjltjfZDeQob6rj/zb5Lla6h
         d5EMH3v0CLHug7a8rHmktmj54OpphX13nZtfYBsXSl5Q+qH7glZS1EuTukxXNx+fiS1o
         HQRw==
X-Gm-Message-State: ACgBeo2z6PWkODRBV/qqR9MRMIdDbcWal/lsllOa1RAhHjC05p/2jtYU
        2IWO5YhBkE0FRUC5YKRho73w/dmfYNU2mEwT7lhLoed4c0aiDQ==
X-Google-Smtp-Source: AA6agR4ZK0b7JGqb3gNnQ0kc+Mxc26x5Tyxqo+Wb8Ot6mgD+DJYcCAk+gYP+dGMh7s8XhA133xWwhPMmPFEC94WJgH0=
X-Received: by 2002:a17:90b:1803:b0:1fb:45e2:5d85 with SMTP id
 lw3-20020a17090b180300b001fb45e25d85mr12555863pjb.163.1661411493324; Thu, 25
 Aug 2022 00:11:33 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?157Xmdeb15DXnCDXqdeY16jXkNeV16E=?= 
        <mdstrauss91@gmail.com>
Date:   Thu, 25 Aug 2022 10:11:22 +0300
Message-ID: <CAAMXCFm12u-v1-AZyYM-hXtTJ1YwFyL26gM8RiONDfMs4+U=WQ@mail.gmail.com>
Subject: ST ST95HF DRIVER security bug
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I found a small security bug in the ST95HF driver in Linux kernel .
Thought it is responsible to report it to you guys so you we can patch it up.
CVE ID was requested,  when it is reserved I will update.
I want to thank Krzysztof Kozlowski for helping me out.

ST ST95HF DRIVER
ST95HF is an integrated transceiver for NFC made by ST,
Buffer overflow can be triggered by the attacker by providing
malicious size in one of the SPI receive registers.

Details:
```jsx
unsigned char st95hf_response_arr[2];
ret = st95hf_spi_recv_response(&st95context->spicontext,
      st95hf_response_arr);
...

/* Support of long frame */
if (receivebuff[0] & 0x60)
len += (((receivebuff[0] & 0x60) >> 5) << 8) | receivebuff[1];
else
len += receivebuff[1];

/* Now make a transfer to read only relevant bytes */
tx_takedata.rx_buf = &receivebuff[2];
tx_takedata.len = len - 2;

spi_message_init(&m);
spi_message_add_tail(&tx_takedata, &m);
```
Driver sets a buffer of 2 bytes for the input bytes but actually
allows the driver to overflow it with any valid SPI message (short or
long frame) in the tx_takedata stage.
It seems like a mistake, but i may be missing something and i am totally wrong.

* Exploitable: I actually think vulnerability can be exploitable by
any device on the SPI bus.
   Exploit is quite low risk and impact is negligible, both because it
requires an actual connected device and because it requires the driver
to be registered.

* Effected versions: v6.0-rc2 - v4.5-rc1

* Introducing commit:
https://github.com/torvalds/linux/commit/cab47333f0f75b685bce1facecb73bf3632e1360

* Code:
https://github.com/torvalds/linux/blame/master/drivers/nfc/st95hf/core.c#L284
https://github.com/torvalds/linux/blob/master/drivers/nfc/st95hf/spi.c#L107

Side note:
I was wondering if maybe the tag is the source for the content that actually
overflows the kernel buffer,  In which case it changes the picture a bit.
But if i understood correctly the messages are used for configuration
with connected device.

Suggested patch:
I am actually not sure if we can somehow limit the size to MAX command length.
I changed it to 1024 because it seems to support 10 bit long frame spi.

```
diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index ed704bb77..741ce633b 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -281,7 +281,7 @@ static int st95hf_send_recv_cmd(struct
st95hf_context *st95context,
        }

        if (cmd_array[cmd].req == SYNC && recv_res) {
-               unsigned char st95hf_response_arr[2];
+               unsigned char st95hf_response_arr[1024];

                ret = st95hf_spi_recv_response(&st95context->spicontext,
                                               st95hf_response_arr);
```
