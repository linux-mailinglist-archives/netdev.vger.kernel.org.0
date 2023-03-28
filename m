Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45B6CB580
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjC1EtT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Mar 2023 00:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1EtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:49:18 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450A310FB;
        Mon, 27 Mar 2023 21:49:17 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id u38so7110452pfg.10;
        Mon, 27 Mar 2023 21:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679978957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eeysXSBzNTunyxSLsLf6PZdL/mFzWkWNNBxhRDgo0c0=;
        b=sOT/hJfYGv2ejCMoZdzlnDkUFF2+vjLZ7kX2YHYip8z0NMKQNzaF/pvn2RD+0E8Z6o
         kR3lOW8TVZqP9krDF+eNXJyCyYlsHOa1aFsUuvmAAE7Wic/SFXpGeA6f/jJndXRepj4W
         W8/vtwaR2gyatnda21dInwxcEdXyWKyLIwJgzJr7zR01pH/Btex5KkD47jkc1K3WsOT8
         CV6wrtTPVos9NPa2V4fTyUS+Ds4TNqRCOKq6B/kqFaOR+9SC6HpteS0wjWUhqV/QZ/7D
         zwA6S/PWYMhXhl23EVOJFwGoRP39RrxBQzVeiXktvw7qW4OoupEDWE3Jcwscu57sDwrS
         y0NQ==
X-Gm-Message-State: AAQBX9fMUk/OZ1aUI6fBZ7In8oBKZCKFc/88kus4HRjF/2JJcDrQ8LUp
        j3MMxf2+gcrM2PSGRHgTp8Bkr+0sE/z7HKY2dSg=
X-Google-Smtp-Source: AKy350aKCni2mn2m2LUsiHsUqDTbJwB8esZTT/Ly4hHJ156kktIhkVqLpPy7U7QY6Wb4YzxDrart1KXMGtX32uIRj2g=
X-Received: by 2002:a05:6a00:1a15:b0:62a:56ce:f90b with SMTP id
 g21-20020a056a001a1500b0062a56cef90bmr7455059pfv.2.1679978956567; Mon, 27 Mar
 2023 21:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com> <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw>
In-Reply-To: <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 28 Mar 2023 13:49:05 +0900
Message-ID: <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
To:     Peter Hong <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 28 Mar 2023 at 12:32, Peter Hong <peter_hong@fintek.com.tw> wrote:
> Hi Vincent,
>
> Vincent MAILHOL 於 2023/3/27 下午 06:27 寫道:
> > eff->id is a 32 bit value. It is not aligned. So, you must always use
> > {get|set}_unaligned_be32() to manipulate this value.
> > N.B. on x86 architecture, unaligned access is fine, but some other
> > architecture may throw a fault. Read this for more details:
> >
> >    https://docs.kernel.org/arm/mem_alignment.html
>
> for the consistency of the code, could I also add get/put_unaligned_be16
> in SFF
> sections ?

It is not needed. OK to mix.

> >> +static int f81604_set_reset_mode(struct net_device *netdev)
> >> +{
> >> +       struct f81604_port_priv *priv = netdev_priv(netdev);
> >> +       int status, i;
> >> +       u8 tmp;
> >> +
> >> +       /* disable interrupts */
> >> +       status = f81604_set_sja1000_register(priv->dev, netdev->dev_id,
> >> +                                            SJA1000_IER, IRQ_OFF);
> >> +       if (status)
> >> +               return status;
> >> +
> >> +       for (i = 0; i < F81604_SET_DEVICE_RETRY; i++) {
> > Thanks for removing F81604_USB_MAX_RETRY.
> >
> > Yet, I still would like to understand why you need one hundred tries?
> > Is this some paranoiac safenet? Or does the device really need so many
> > attempts to operate reliably? If those are needed, I would like to
> > understand the root cause.
>
> This section is copy from sja1000.c. In my test, the operation/reset may
> retry 1 times.
> I'll reduce it from 100 to 10 times.

Is it because the device is not ready? Does this only appear at
startup or at random?

>
> >> +       int status, len;
> >> +
> >> +       if (can_dropped_invalid_skb(netdev, skb))
> >> +               return NETDEV_TX_OK;
> >> +
> >> +       netif_stop_queue(netdev);
> > In your driver, you send the CAN frames one at a time and wait for the
> > rx_handler to restart the queue. This approach dramatically degrades
> > the throughput. Is this a device limitation? Is the device not able to
> > manage more than one frame at a time?
> >
>
> This device will not NAK on TX frame not complete, it only NAK on TX
> endpoint
> memory not processed, so we'll send next frame unitl TX complete(TI)
> interrupt
> received.
>
> The device can polling status register via TX/RX endpoint, but it's more
> complex.
> We'll plan to do it when first driver landing in mainstream.

OK for me to have this as a next step. Marc, what do you think?

> >> +static int f81604_set_termination(struct net_device *netdev, u16 term)
> >> +{
> >> +       struct f81604_port_priv *port_priv = netdev_priv(netdev);
> >> +       struct f81604_priv *priv;
> >> +       u8 mask, data = 0;
> >> +       int r;
> >> +
> >> +       priv = usb_get_intfdata(port_priv->intf);
> >> +
> >> +       if (netdev->dev_id == 0)
> >> +               mask = F81604_CAN0_TERM;
> >> +       else
> >> +               mask = F81604_CAN1_TERM;
> >> +
> >> +       if (term == F81604_TERMINATION_ENABLED)
> >> +               data = mask;
> >> +
> >> +       mutex_lock(&priv->mutex);
> > Did you witness a race condition?
> >
> > As far as I know, this call back is only called while the network
> > stack big kernel lock (a.k.a. rtnl_lock) is being hold.
> > If you have doubt, try adding a:
> >
> >    ASSERT_RTNL()
> >
> > If this assert works, then another mutex is not needed.
>
> It had added ASSERT_RTNL() into f81604_set_termination(). It only assert
> in f81604_probe() -> f81604_set_termination(), not called via ip command:
>      ip link set dev can0 type can termination 120
>      ip link set dev can0 type can termination 0
>
> so I'll still use mutex on here.

Sorry, do you mean that the assert throws warnings for f81604_probe()
-> f81604_set_termination() but that it is OK (no warning) for ip
command?

I did not see that you called f81604_set_termination() internally.
Indeed, rtnl_lock is not held in probe(). But I think it is still OK.
In f81604_probe() you call f81604_set_termination() before
register_candev(). If the device is not yet registered,
f81604_set_termination() can not yet be called via ip command. Can you
describe more precisely where you think there is a concurrency issue?
I still do not see it.

> >> +               port_priv->can.do_get_berr_counter = f81604_get_berr_counter;
> >> +               port_priv->can.ctrlmode_supported =
> >> +                       CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_3_SAMPLES |
> >> +                       CAN_CTRLMODE_ONE_SHOT | CAN_CTRLMODE_BERR_REPORTING |
> >> +                       CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_PRESUME_ACK;
> > Did you test the CAN_CTRLMODE_CC_LEN8_DLC feature? Did you confirm
> > that you can send and receive DLC greater than 8?
>
> Sorry, I had misunderstand the define. This device is only support 0~8
> data length,
  ^^^^^^^^^^^

Data length or Data Length Code (DLC)? Classical CAN maximum data
length is 8 but maximum DLC is 15 (and DLC 8 to 15 mean a data length
of 8).

> so I'll remove CAN_CTRLMODE_CC_LEN8_DLC in future patch.
