Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25CF590AF2
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 06:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiHLEJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 00:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiHLEJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 00:09:48 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE92A0302;
        Thu, 11 Aug 2022 21:09:47 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id g5so31201274ybg.11;
        Thu, 11 Aug 2022 21:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VElpo/hJHfw2RvZvud8eiJu3fb0VVkH8EWFL092LbyM=;
        b=blP25JnLo2TmHjHag2bR+teBEK87Mz7SHz967KGBmFf1p5xgNeulgtkLNaOZsvHcFj
         QTk4BI80mvvcE3TIP29g7aY4kmQ2qzqwYi98tdOyIcC9kPFx894zioqG/H5KiYSsm11b
         1vOiScZd46PL3CMmNCrAhbxDa0dElvnru66liMq8I7HbUnqTWSibq9LDSmmxNh5AjdHp
         jW4QKqsb5GiJX3ivYl19mwURClKJAgisYLz2AkCKMnyDPKfMmzC9vuByhCuFMtubmnUM
         tEvwW/AK9qAKyhe2AAgc4blnry8Ish4U7kal/2L8VJL7cx3q1k5yffy9/pBPbnNcgDGy
         +cXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VElpo/hJHfw2RvZvud8eiJu3fb0VVkH8EWFL092LbyM=;
        b=DqcRAAKJGZWl2phrrHPrTgrRy7tveR+2T17ngEJbZcGxGrmau6+HGbaWKiG72a6gTN
         m8zX4cibP4auDY3KhLoGKWUwTrnd81+YIXbnYkuNZivow2n4fgegOEbc5to+vfaWpkXi
         7pgG5FVq1cKknSe3SS9S/E5K4AGXeueBStPIFwGsx5XqvkADapSll/YyPv7dZihgIiej
         aix4cTeYHeD7FyLyd5DxCPdORMTthntsq5xsZ+x1TEz7qRzILNP8vjVvS3mvN9wzfgBU
         JfgZsWiPaZnXQvw2Tk2MDUEDyahR6bT0ULeYJyP+3eTf/+sb3jv3NBz19WoU99CiiUvH
         g06g==
X-Gm-Message-State: ACgBeo1ZysUrCmCVhW0WUp7iGNl4U1HmE7U/B9Q95mtbQOFlrMy0T66f
        AjUgrrWfk5Q0eHipkS7Atfj81iR9Z9dMNRN1aaE=
X-Google-Smtp-Source: AA6agR7aS8A13CrYgjl8GiA4yxSMSh8285o1W6Z9Itk2qso727yl4VcHZ225ZGHVW28V8MpIdpTrAfpF1lIigRh3rhI=
X-Received: by 2002:a25:da13:0:b0:672:6a10:a033 with SMTP id
 n19-20020a25da13000000b006726a10a033mr2082818ybf.617.1660277386448; Thu, 11
 Aug 2022 21:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <YvVQEDs75pxSgxjM@debian> <20220811124637.4cdb84f1@kernel.org>
In-Reply-To: <20220811124637.4cdb84f1@kernel.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 12 Aug 2022 05:09:10 +0100
Message-ID: <CADVatmPQxgQoQ5o_9PhRphekhnmjndq2jd+0yXnDc1OuUphdpA@mail.gmail.com>
Subject: Re: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-bluetooth@vger.kernel.org,
        linux-next <linux-next@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 8:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 19:53:04 +0100 Sudip Mukherjee (Codethink) wrote:
> > Not sure if it has been reported, builds of csky and mips allmodconfig
> > failed to build next-20220811 with gcc-12.
>
> I can't repro with the cross compiler from kernel.org.
> Can you test something like this?

With this patch I get new failure:

In file included from net/bluetooth/l2cap_core.c:37:
./include/net/bluetooth/bluetooth.h: In function 'ba_is_any':
./include/net/bluetooth/bluetooth.h:346:16: error: returning 'void *'
from a function with return type 'int' makes integer from pointer
without a cast [-Werror=int-conversion]
  346 |         return memchr_inv(ba, sizeof(*ba), 0);

So for a quick test, I modified it a little (just a typecast) which worked.

diff --git a/include/net/bluetooth/bluetooth.h
b/include/net/bluetooth/bluetooth.h
index e72f3b247b5e..19bdd2520070 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -341,6 +341,11 @@ static inline bool bdaddr_type_is_le(u8 type)
 #define BDADDR_ANY  (&(bdaddr_t) {{0, 0, 0, 0, 0, 0}})
 #define BDADDR_NONE (&(bdaddr_t) {{0xff, 0xff, 0xff, 0xff, 0xff, 0xff}})

+static inline int ba_is_any(const bdaddr_t *ba)
+{
+       return (int) memchr_inv(ba, sizeof(*ba), 0);
+}
+
 /* Copy, swap, convert BD Address */
 static inline int bacmp(const bdaddr_t *ba1, const bdaddr_t *ba2)
 {
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index cbe0cae73434..67c5d923bc6c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2000,8 +2000,8 @@ static struct l2cap_chan
*l2cap_global_chan_by_psm(int state, __le16 psm,
                        }

                        /* Closest match */
-                       src_any = !bacmp(&c->src, BDADDR_ANY);
-                       dst_any = !bacmp(&c->dst, BDADDR_ANY);
+                       src_any = !ba_is_any(&c->src);
+                       dst_any = !ba_is_any(&c->dst);
                        if ((src_match && dst_any) || (src_any && dst_match) ||
                            (src_any && dst_any))
                                c1 = c;



-- 
Regards
Sudip
