Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351C95703CC
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiGKNFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiGKNE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:04:57 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CD92F384;
        Mon, 11 Jul 2022 06:04:56 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id u9so6536629oiv.12;
        Mon, 11 Jul 2022 06:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=77Is5fWIoRT3iVYxrS3HzyvU2jWJTRTch4gghCpw35I=;
        b=dccCy3PXmVhy4MAgjFauuvTXTdIBeHypOzLdGk7Q2Z8gyGDgqID9tVmXRl8Oh09TqH
         CGfbjbdCEYGOnOnVkUsxJ7b+4u/Zf70MY4EpSCAojPI4iW1VSNH2nO9xhBAJpESYFjFd
         Ly8m7rrE+4Kd8OZOcLDe2/lbfwABLhqr7DUkUvrZDzqn2ZwwSuqxZEECaMS7SBrqkvlQ
         nVvl2J/MSf2Gbz5UvQYI7TUtT1udM9XfxryvMmeU+w4BqsQXxJXj9xN8Z04cnbWp0pfS
         UNNOtmUgKCC/Y1iaozRxhnCVroV2A/WBj2JZ2PJNZPw9q23Tx3/B//UrwE4RyU+j2c+b
         C/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=77Is5fWIoRT3iVYxrS3HzyvU2jWJTRTch4gghCpw35I=;
        b=fg5NFA1QLA40eMDWb0noix3LY1g/zS+7czIPsuhGNeNUckAod5wb4kabB4KOzF1nS1
         8AGE/PRGFymAJjR9m5LgjzaWnx8XXIVsi4+HZ6NKBYWSqQoSHjejAxxoqupu20xu76Iq
         wMMzXWY6+8Vx/TGSZGr4TLekxWYAQ/GVunnIDQHT2UtRC5YcGcSvWfZUOpQsIvsOB+lz
         DrNZ/Mb15nnVP0dB8a1PQm2dSivLbOmEf3F8ELjOvtO5e20U1MrsYYx5vLZKYqKR3zlW
         uzsRbsuf1ycc/JID++e9mh5lUlmjvdp91PaGfOhgkpLAbRDZNhp8rSq60S7d+bwDx+Ww
         cJoA==
X-Gm-Message-State: AJIora9pVd6rOQQav8gWrv/TDZB8Ne91lTnj6g61zWEMHb+Zt71cL5cb
        IL+s+9KMrzcQTWkUqejOmmS3XVVCK2I=
X-Google-Smtp-Source: AGRyM1tu2PpXLYFVv4NmNN1XoIeut5xCeFu6SxBn1QQk9mbbyYxGe53MniBqfvwtohiIbkdHfSRL1w==
X-Received: by 2002:aca:ab87:0:b0:339:cabe:31d6 with SMTP id u129-20020acaab87000000b00339cabe31d6mr6784434oie.280.1657544695404;
        Mon, 11 Jul 2022 06:04:55 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id y10-20020a9d518a000000b00616a2aa298asm2542816otg.75.2022.07.11.06.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:04:54 -0700 (PDT)
Message-ID: <8353466644205cf9bb2479ac8ced91dd111d9a01.camel@gmail.com>
Subject: request to stable branch [PATCH net] net: usb: ax88179_178a needs
 FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Mon, 11 Jul 2022 10:04:51 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think that this patch should be include in stable:

36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")

The problems that it fixes are present in stable branches.


