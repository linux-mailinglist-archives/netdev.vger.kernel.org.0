Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9340543EB0
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiFHVf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiFHVfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:35:54 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B764A925
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 14:35:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h5so30002121wrb.0
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 14:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=G1SeVyk2Nyojrc2cD4/xuDKokGyeVSNBkJ8po2K9wXQ=;
        b=Jnw6sPiQ4LrB7P+6mEXd9XBi7+OIW0HEGmv2wxLvOCEtXxAfX3fpltoft+Jwlfkmn6
         qspMIBl7ZBDynqEW/qRthD8qUE/W0jxMxJVOpFNH4dsE4I5Y7Fz6rlTXVc2XNFuiFS3y
         sLbe6ldBF/2wwtTTH7qGxau5U7xySpinr6AwMZnxb8wj2h/RL46p8yrf4IRf89Xo4hag
         a2kRNQuhaon0iZ70oKv4f3EOd+wqlpqNeUGAJ9RPpK3dPct9O1h9vmOlrZeuntwLgAwa
         oDXrwxCi5DcRLOsNGshMHB/9Lf1bs139OPi6Y/sPWsZpuWI98bvmq78k0eEsCE6gwUVI
         EBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=G1SeVyk2Nyojrc2cD4/xuDKokGyeVSNBkJ8po2K9wXQ=;
        b=fvOqeMpX7/X1Opk0C6L9HPLBwP8uXvmAFcKvr5R+lQevci1vJEKHixBXL/LD+OvKu/
         sIS9Jf4Mz9xLsIy8mqGxztrf9ZkFqk3gNSQJmYk0P1QjuQtKqMb03+SRR0yDlfT0iEf8
         8gIL4b3CAwEtuCz/jB0fCfcZOrfMkTpeziHsgIjutLeFneKSpO5YbPNe7iLmU11cHUae
         1fIsvBAGTxOwc0ig79VHJPOYMcKD2SV5naur3hb4h66QRuWjZ2cjqjRKlLkZotY92cdO
         +BsfiwU2/nMSzJua3p13YBbdGVKy1vpLJ2ZUSsPJ9j7aAgr5cr8NaKBEvxCvLH+T7I6p
         McIw==
X-Gm-Message-State: AOAM533aog1vXBgZZQFC3/qG9J84+QNYTr3OUGPtMP5DusIoR1OgTba1
        rs89OEub921NafBMLiwAmugfHbh2VileFhCowOQ=
X-Google-Smtp-Source: ABdhPJytkVkskHNlbRYxCM4MAyIawml7/v3hTc5nZUEBDWUZ5RF/SHINESVnGTyWGvWab1WOylEt97TAVZ8SsQPm9JU=
X-Received: by 2002:a5d:4526:0:b0:210:bac2:ba63 with SMTP id
 j6-20020a5d4526000000b00210bac2ba63mr36023740wra.677.1654724152606; Wed, 08
 Jun 2022 14:35:52 -0700 (PDT)
MIME-Version: 1.0
Sender: armtonney@gmail.com
Received: by 2002:a7b:cc12:0:0:0:0:0 with HTTP; Wed, 8 Jun 2022 14:35:52 -0700 (PDT)
From:   George Johnson <georjohns57@gmail.com>
Date:   Wed, 8 Jun 2022 22:35:52 +0100
X-Google-Sender-Auth: AI9JWF2X3lS2eLy1NNVEZHTxONM
Message-ID: <CAJM5FosPVmPMyowtuM6obx6Jd9dqB+YDWmybKUdtXO_Ei53QDA@mail.gmail.com>
Subject: Informartion for 08/06/2022
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I have a very important transaction i would like to carry out with
you. do write me back on: georjohns57(at)gmail.com for more details.
Regards,
George Johnson
