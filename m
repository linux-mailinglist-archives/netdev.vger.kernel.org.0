Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BB14BD64B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345705AbiBUGyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 01:54:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345703AbiBUGyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 01:54:09 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643EE637E
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 22:53:47 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2d6923bca1aso118286317b3.9
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 22:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oJuoI6b/Bgo1YbSVyQXX8LhfyAXbj1TaNpf59CA/fUc=;
        b=f2H9v6pfUOq3d6ft+P+hKFdvvlzgQRXAQxaUmEb0qQlQL9HoxcDCho9PocYBCikMpG
         IAcUtvgt8rG6g0rrpdCb7mJxTEt9TpgZlq0/MiTNt4lMk74wuYQnczKClhrVZLheBIB6
         blLJZKTGW/MbQuIRO0ij+KJhLZ0tl7Z+RU5L7055P6srcPMQeNEuxdNco4TK3YCFZHEV
         nXbZtqWMmzKcYg/Nxm7soqWbWiSxVhkllGOQiTK5PcSmUYFh/Icdo9jrWazbqjjszual
         OEbM1PdWFXosVNAxBhGzJwL2YzFgIdYaeTCVIPpBaDz7US9zcHx/aAALc2EIkCzyHNVn
         9F8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=oJuoI6b/Bgo1YbSVyQXX8LhfyAXbj1TaNpf59CA/fUc=;
        b=uEpiH3npM4A+7M+6kA0FL0x8Al03AHIaME6tY9vSXu57pIq2BhBW9DCRRn3f2x9ZEQ
         IFAURnG9EsNWcKu9vVp7wc1b3UH/fbXrnz++RjXjsI0xMGpFRV7XPE3RU1TP9q5QrfEa
         XfY3TYHgieuADh64GVpfu/gy+18DugJqbUUkvU2NggC6yApKrHEIFd0/epj8i1oUKQsZ
         6Xc2ar4OG6s5QEybtZvol1nwiaPphn7KIu8Rs9nuj+GJxXRrfPIdMz/1D5/cX7oDRFGf
         jKSbRYO22G9qwNqZIFXDYzkyXKM/o6D5LyN006TQM4awl9BhMlfMoUnwSfrRU6blSZRG
         T2Rw==
X-Gm-Message-State: AOAM531xKrs/4pyE/UPLsiu5K++8OEKFLZnwSG1ZXPaZ6LnxP7/0ulm8
        A68jR75iXElJQcEo0hbg2P1VU5mvQCq2OAGrGy8=
X-Google-Smtp-Source: ABdhPJy7Cc30SMmKXJshJ8dYwGqd1DdpaGLyjC/18EKxzBcP9WePJfhEbsfK3GArEaABPOYPzd5D8B9BsVFIk0VPJYY=
X-Received: by 2002:a81:ac41:0:b0:2d7:4966:1eb5 with SMTP id
 z1-20020a81ac41000000b002d749661eb5mr3118897ywj.103.1645426426600; Sun, 20
 Feb 2022 22:53:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:8ca5:b0:210:6095:95d2 with HTTP; Sun, 20 Feb 2022
 22:53:46 -0800 (PST)
Reply-To: drbellomusa009@gmail.com
From:   "Dr.Bello Musa" <musaboy1988@gmail.com>
Date:   Mon, 21 Feb 2022 07:53:46 +0100
Message-ID: <CAH3v6_+a6bVJyoQAaNzqEBHN=Y-SStNBNNzYuytZL_x4McC+9A@mail.gmail.com>
Subject: =?UTF-8?B?6KW/6Z2e5biD5Z+657qz5rOV57Si5YWx5ZKM5Zu955qE5YWz5rOo44CC?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=6.8 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UPPERCASE_75_100 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1131 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9123]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [musaboy1988[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [musaboy1988[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [drbellomusa009[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 UPPERCASE_75_100 message body is 75-100% uppercase
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5biD5Z+657qz5rOV57Si5YWx5ZKM5Zu95Zyo6KW/6Z2eDQowMSBCUCBPVUFHQSBCVVJLSU5BIEZB
U08g55Om5Yqg5p2c5Y+k44CCDQoNCuazqOaEj+WfuumHkeaJgOacieiAhe+8mg0KDQrluIPln7rn
urPms5XntKLlhbHlkozlm73oh7Tlh73mgqjvvIzpgJrnn6XmgqjvvIzkuIDkupvln7rph5Hlt7Lo
jrflvpfkuJbnlYzpk7booYznu4Tnu4flkozkuJbnlYzmgLvnu5/ogZTnm5/nmoTmibnlh4bvvIzl
j6/kvZzkuLrmgqjov4fljrvlh6DlubTmiJDkuLror4jpqpflj5flrrPogIXmiJbmgqjnmoTlrrbk
urrlj5fliLDkuKXph43lvbHlk43nmoTooaXlgb/lvaLlvI8NCumAmui/hyBDT1ZJRC0xOS4uDQoN
CuazqOaEj++8muivt+aCqOehruiupOaCqOeahOacieaViOS/oeaBr++8jOS7peS9v+mTtuihjOiD
veWkn+mAmui/h+aCqOS4juaCqOiBlOezu++8jOS7peehruS/neaIkeS7rOato+WcqOS4juWPl+W9
seWTjeeahOS6uuaIluWutuS6uuaJk+S6pOmBk+OAgi4NCg0K56Gu6K6k5Lul5LiL5L+h5oGv77yb
DQoNCuivt+Whq+WGmeaCqOi6q+S7veivgeS4iueahOWnk+WQje+8mg0K5b+r6YCf6IGU57O75oKo
55qE55S16K+d5Y+356CB5ZKM5Lyg55yf5Y+356CB77yaIOWcsOWdgO+8miDnlKjkuo7pqozor4Hn
moTouqvku73or4Eg55uu55qE77yaDQoNCuasoui/juaCqOeahOe0p+aApeWbnuWkje+8jOWboOS4
uuaIkeS7rOaEv+aEj+aOpeWPl+S7u+S9leWPr+iDveaJk+aJsOaCqOeahOmXrumimOOAgg0KDQrm
raToh7TjgIINCui0nea0m+ephuiQqOWNmuWjq+OAgg0K5rW35aSW5pSv5LuY5oC757uP55CG44CC
DQo=
