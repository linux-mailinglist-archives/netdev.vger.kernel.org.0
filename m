Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3B65D705
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbjADPQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbjADPQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:16:09 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA8EB1
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:16:04 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id pe2so16434001qkn.1
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 07:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TzsECpQQZWszrfGpCKzDzrw8iWPksBCj12PLooJzSsE=;
        b=EwuAJry5Zl0FnUW8Zk30jjzflS7lQFozLP3L7NRz2DOVvfuHigVEC8yaia+Yx3K5fM
         B/Ml5+VpxzOwnrcKrwoNcvA8MvPLeJOoKmBbyyP3a9WZlpjilXYxr+6u23/RnCGjS+2s
         zKgcVfRr01f/2r2uehg8LV29UQBR2LtcAW9c0JdApZj7T1qDSr51brXLqPe1Oyu176Xh
         nIcmwSrPsT60DwIOdrxTi9qqxv49GN+XkKxYyud6qQMd56UtvD/yykOKESKQXT29OKwS
         FXCLiy/BwWW1vNtimjJAlTN9J5/6XZRegLWNPBt517d6VSoN+bzkhjnTIMwv2paZzRzd
         aHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzsECpQQZWszrfGpCKzDzrw8iWPksBCj12PLooJzSsE=;
        b=EanWBpdI9UpaLBLZ/eddAE9ho3IezY1dkjxu+GLOtREN1EDGj3l7emRrG7BhcinZaz
         ORFgZgU+1xrld/7HJl/JCCf3UwNibWvQEBdS0qDbsGXPBG9vP8vE7WJDO4qHvvVLFr81
         qXzqfnIXsfJoDnuLoR+dnfN1j/B55a7fHBRSxJUhj4JkWSV7Vf/zyPy1mELg9OlJ77sv
         y2ZXiFVfLoi49xVgqPtU2Ar4H45JSS21C1XvAwIrmIDDwkbORR+VOfBOAJZXTNSw+TYN
         Dprr3i2EFk6NTIffrEfMx9GVXLcVv24GayExH5M/LaE4Q6TgHAs9d3t2zzl1CmKOrw4j
         nAGw==
X-Gm-Message-State: AFqh2kr14QMN9Uoihmoy+1vGz0GCrFhNAXnMsR2kGHcC/iQkPNm1oxs1
        9D98y6E61vFXiYljJfBlqfXbfRr1yOGXrf+wUzok83qm8ENVAQUo
X-Google-Smtp-Source: AMrXdXtJYsmAhuX4DPLmNPVvyAVBmbhKM+wZX5KGaCJsjY0iiIULcAHLf3BwtYr4Zn6Zi+HcHyu1953gNRBfFHEvN5k=
X-Received: by 2002:a05:620a:1327:b0:6ff:df2:2936 with SMTP id
 p7-20020a05620a132700b006ff0df22936mr1608229qkj.138.1672845363686; Wed, 04
 Jan 2023 07:16:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:f2ca:0:b0:531:9b30:dcb with HTTP; Wed, 4 Jan 2023
 07:16:03 -0800 (PST)
Reply-To: garryfoundation2022@gmail.com
From:   Garry Myles <salisuyusuf559@gmail.com>
Date:   Wed, 4 Jan 2023 18:16:03 +0300
Message-ID: <CAFFimn0Ay0=rtbeVBvgfUKvvyxQTA6P-Cca_9vu7R1S2SYN6jQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Sch=C3=B6nen Tag
Sie haben eine Spende von 2.000.000,00 =E2=82=AC von der Garry Charity Foun=
dation.
Bitte kontaktieren Sie uns =C3=BCber: garryfoundation2022@gmail.com, um
weitere Informationen zur Forderung dieser Spende zu erhalten.

Dein
Garry Myles
