Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E888C5528EF
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 03:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233151AbiFUBSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 21:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiFUBSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 21:18:45 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F1B6334
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 18:18:44 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id l24-20020a0568301d7800b0060c1ebc6438so9607312oti.9
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 18:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=MngNzano96NshprHZefqNkDNCS2rqjZ6FSbuKWRYkVw=;
        b=Y0Z+4gHehU2KDA7VmFMqvIHFBJbSqKa8DZ0uBIbfZzfFhoRZFCSls3AOYr4dMsRrgM
         gc4OiEBY0890xQORubyRV6LFoxbNxtEMl66N7pUW4mZjPo86NDIjO0k4yNuc2r9SMKq6
         gUd/f1w0m37bPCSAJqoBdXxw2sMnXJhZpvLfD3Cq4FTMhXDxFHIC/QFg+X8mrSBZhbHK
         Wrb/FPMU+kmZOIRj9FMX7l3dfCXcnlESCdWJ1KjcFMheM2y8ezjaEZ897LOJpGXPxLQ3
         cadcsIl1i8MGHEjq0E4p8RA1qQiAfTnJu2AcboCRKgCDkJovWARl5rR6OvDZOJGzRKt0
         Q2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=MngNzano96NshprHZefqNkDNCS2rqjZ6FSbuKWRYkVw=;
        b=j0XiUvw9KW6p2bpPHG/u0WSi5vyUd9Wis7/MDYxuu+tbHjONflXINQ0e+lmOIGUKo8
         x5ICLFNL9L0UydxqFfS3ldov2SpMsTEVfdJwd8UreJZz4do5oDWtqS3rV7IijMmNSBpO
         tSW3V2O/qz2D5p6O7zpvfAkG5zB0pa0ywkPGY5/dgzRlgRVjGyxOLyJi+qkifcodA0vF
         JOpqeT1Aoy2Ra0AO9Y/WDfBOiXkDXOBivtDhuUumMAN9VGJaceZfE915wwZk4Eu7ulJB
         WWtEieDB5PuAP0AmAQA3S6Dr4uvDq6yy1AH3uwIT/zvZoPXw1BWnX1wft5iSrPix5/Dz
         6r7Q==
X-Gm-Message-State: AJIora8foE4WbEmU0QLZSbewZw28NFZClbwNq6QmEMvkyn+PyAhAVQmW
        ffQxWxm3Q8kITggqZLc0cXV/NFpEqZIliQ==
X-Google-Smtp-Source: AGRyM1s2NBuaxHMiSCn7G/H2ZEibzhfZJAyVsMiyC+UolgQG8bIa35lgSpkJ7U7itF4jSYYHVp7+kQ==
X-Received: by 2002:a05:6830:55:b0:60c:3192:695e with SMTP id d21-20020a056830005500b0060c3192695emr10600713otp.22.1655774323351;
        Mon, 20 Jun 2022 18:18:43 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8e3a:451d:181c:d286:89d5? ([2804:14c:71:8e3a:451d:181c:d286:89d5])
        by smtp.gmail.com with ESMTPSA id k19-20020a056830243300b0060603221255sm8547162ots.37.2022.06.20.18.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 18:18:42 -0700 (PDT)
Message-ID: <72d0a65781b833dd3b93b03695facd59a0214817.camel@gmail.com>
Subject: Re: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Jose Alonso <joalonsof@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 20 Jun 2022 22:18:41 -0300
In-Reply-To: <6dacc318fcb1425e85168a6628846258@AcuMS.aculab.com>
References: <24289408a3d663fa2efedf646b046eb8250772f1.camel@gmail.com>
         <6dacc318fcb1425e85168a6628846258@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
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


On Mon, 2022-06-20 at 03:45 +0000, David Laight wrote:
>=20
> > -                       ax_skb->truesize =3D pkt_len + sizeof(struct sk=
_buff);
>=20
> You've 'lost' this lie.
> IIRC the 'skb' are allocated with 64k buffer space.
> I'm not at all sure how the buffer space of skb that are cloned
> into multiple rx buffers are supposed to be accounted for.
>=20
> Does this driver ever copy the data for short frames?

The driver receives a skb with a URB (dev->rx_urb_size=3D24576)
with N packets and do skb->clone for the N-1 first packets and
for the last return the skb received.
The usb transfer uses bulk io of 512 bytes (dev->maxpacket).
skb_clone creates a new sk_buff sharing the same skb->data avoiding
extra copy of the packets and the URB area will be released when
all packets were processed (reference count =3D 0).
The length of rx queue is setted by usbnet:
#define MAX_QUEUE_MEMORY        (60 * 1518)
...
        case USB_SPEED_HIGH:
                dev->rx_qlen =3D MAX_QUEUE_MEMORY / dev->rx_urb_size;
                dev->tx_qlen =3D MAX_QUEUE_MEMORY / dev->hard_mtu;
                break;
        case USB_SPEED_SUPER:
        case USB_SPEED_SUPER_PLUS:
		...
                dev->rx_qlen =3D 5 * MAX_QUEUE_MEMORY / dev->rx_urb_size;
                dev->tx_qlen =3D 5 * MAX_QUEUE_MEMORY / dev->hard_mtu;

>=20
> There ought to be an error count here.
yes.
> I know there wasn't one before.
>=20
>         David

Jose Alonso


