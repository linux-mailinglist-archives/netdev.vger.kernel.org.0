Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F0B570434
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiGKNYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiGKNYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:24:41 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273292F384;
        Mon, 11 Jul 2022 06:24:40 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id f62-20020a9d03c4000000b0061c2c94ab8dso3959944otf.10;
        Mon, 11 Jul 2022 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=gwBX5YajfL6NKbRkA7rxDkc+s2uAxeQ+NJtbSZDDUqU=;
        b=kBIjIEApv8bztvYa81Uy4rP/IRbjwbEjjT3PHEYBQMNzBDNZN7j7yaCyb4tuzpdwR4
         SIS2QWN3AztpF2LjjGWwr27WFmnTKWTevFcVgFClR/MhhplcBpDZsRdGPz/4m8KbnsHb
         bI2gj4WOJAe2yF18sZD9UOY5uyW//R48QFoaCKe4J1q1ekHgEpNiLL5O1zqoKWr2AwIK
         5GiPgVv6L4ysTp+ChaP7ScbrNn74zv4J2tFDQOHVMM009hmzG+bm3Vdphbx3NAgKY2w8
         0GI862SENHBRQRNalPXdbOGmjBNHCam2iPcbBgxzD2jDKAUguGD3cOsovi71mSqVwLQZ
         Qq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=gwBX5YajfL6NKbRkA7rxDkc+s2uAxeQ+NJtbSZDDUqU=;
        b=fOc2/QDAlJ/gL5rdMIdnGdJupKmuCJP4myPymEBxpr2nL1+DIZEFZcHTQFHi9zfIv1
         f2PIcORyjtOFxV4IoY8/7m6X1YT3QuI0DG3ZFzEOs6pqLWezAozuhDtv5pXXaPKPM8fA
         sSBE5MgDtVRoH0Z9pLapiLE91j2q4Wnn/RY8G8OEDForHu3xfwPzMmqXEEmWulnhH8Wu
         k7smOQy5DXcrfjCQWFQ00PSJBphMwSostuLaaWSycs3DTseQc09neipRlMK/EtZH+frw
         iojdI1N2izE0iXP83xY/mrKc9dYESKgS0ZEWBA+Ii77yaW7zOjnh0oMGGcr0gfCmkML5
         NYDw==
X-Gm-Message-State: AJIora/SbgH64NKDvjEf2febx9Sl8dP1shqvFHjeCroh7ILwzxkojpp5
        SeP8YixIYx578jZ+ejogAFweYgaKdvo=
X-Google-Smtp-Source: AGRyM1sbU7nie0dKITiKYenwg5KmRekDlRYnHorG0j++Oq3mkIgn34ViPPvwgKSCmtExbKw8NIv7Ug==
X-Received: by 2002:a05:6830:20ca:b0:61c:5150:d295 with SMTP id z10-20020a05683020ca00b0061c5150d295mr1138969otq.255.1657545879535;
        Mon, 11 Jul 2022 06:24:39 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id t32-20020a056870602000b00101cdb417f1sm3146691oaa.22.2022.07.11.06.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:24:39 -0700 (PDT)
Message-ID: <e388870f72a6b13e801f4114bfb92537940efd6e.camel@gmail.com>
Subject: Re: request to stable branch [PATCH net] net: usb: ax88179_178a
 needs FLAG_SEND_ZLP
From:   Jose Alonso <joalonsof@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date:   Mon, 11 Jul 2022 10:24:35 -0300
In-Reply-To: <Yswijtbd3nGjVF35@kroah.com>
References: <8353466644205cf9bb2479ac8ced91dd111d9a01.camel@gmail.com>
         <Yswijtbd3nGjVF35@kroah.com>
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

On Mon, 2022-07-11 at 15:15 +0200, Greg Kroah-Hartman wrote:
>=20
> What stable kernels do you want this backported to?
>=20
The same kernels as 'net-usb-ax88179_178a-fix-packet-receiving.patch'

releases/4.14.287/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/4.19.251/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/4.9.322/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/5.10.129/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/5.15.53/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/5.18.10/net-usb-ax88179_178a-fix-packet-receiving.patch
releases/5.4.204/net-usb-ax88179_178a-fix-packet-receiving.patch

--
Jose Alonso
