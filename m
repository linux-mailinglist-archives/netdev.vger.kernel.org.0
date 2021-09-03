Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D76400665
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350417AbhICUPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239368AbhICUPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:15:38 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3CDC061757
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 13:14:38 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id g9so136518ioq.11
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 13:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=klu68g+a7JwyJri/TU9nMjBbX2K7Jipbwhe0jYyf8sk=;
        b=ziYI2mJKwjNp329iJEVAGP6BlhkZHa27nfhbTIin+xD+KTQNggFl7DYmD2x1ZxgiyJ
         YGGRTs/H55ofvjb2frJWB9UCYgzt6JT/gcy2sFwibZ+cBDH69IIXcvKpC3pjl7/TThnF
         btgzc5xpjUGlf15iGenje0FqZMXEdbbvDtIA6Dzsu2inksYvD7RxL0eS4UtbR6AilrgN
         SXVj3TdyfWDu17P1eHWzJXzxGGcaWbbpsd3xuU0zmSFJuVTpXl3EGIKmq+O0HADwa2ja
         Q+upKfBLroioZafyeLANs4waTu0uF5ZELu2D0LoXxCIVvUFS11se0EmofD6+Zf/BOGtt
         0LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klu68g+a7JwyJri/TU9nMjBbX2K7Jipbwhe0jYyf8sk=;
        b=YTC1b6UModMUZq3oyEvAilnzbIC9Peo5MZi0v/hOt5MMRiVd7mLuKcyshymlC/TSnA
         9ArP1XeolWlR0+C3qw+Ch5La6oC4sWRM6BnPPtyvZ7Q13JpQgxcMFUDALdMD71n2x9lD
         SSmsON4Fo3kYlKgFBEgzgzz4zKf9krdNW7hhg8R+LIsZ1Ea1FZSAeiogDnEYng0m4zrc
         QfmjqanBFbFsJ3xjhabBmIYk51DmB/2iWBSwQ8BSqIHbiNvnAJ5niwvtzgtKFi6F+Z3l
         N6y4o7+gHt/DmSwi66mAuIdPyj+tBEOVh4lXXGvHJz1sXhaQkIItVrT1KgA1QXpSsDQ5
         PGPg==
X-Gm-Message-State: AOAM533NjrK0H+fL63LIOSqopWGnZPZKtuhMV0rU9+q1HVbotDCzw4AA
        +Ji2GhKrixeFXWtU8UAP0kQJvZNYTXjbPkxvfc6wEw==
X-Google-Smtp-Source: ABdhPJwCrVb6ACMC2TUuqoNLG0sMEntR7PAVyys15e4JFobZ0E/hWkCtTp8QNOLOXnnsUgatQ6ITY9vTkWKACcd+gtE=
X-Received: by 2002:a5e:9819:: with SMTP id s25mr566253ioj.63.1630700077910;
 Fri, 03 Sep 2021 13:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-4-gerhard@engleder-embedded.com> <874kb21sb3.fsf@vcostago-mobl2.amr.corp.intel.com>
In-Reply-To: <874kb21sb3.fsf@vcostago-mobl2.amr.corp.intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Fri, 3 Sep 2021 22:14:26 +0200
Message-ID: <CANr-f5zkr90FOQ5did25HM0WRn0RKLmgfJXCkH-Br+0kZZxAKw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The TSN endpoint Ethernet MAC is a FPGA based network device for
> > real-time communication.
> >
> > It is integrated as Ethernet controller with ethtool and PTP support.
> > For real-time communcation TC_SETUP_QDISC_TAPRIO is supported.
> >
> > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > ---
>
> [...]
>
> > +static int tsnep_netdev_open(struct net_device *netdev)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > +     void *addr;
> > +     int i;
> > +     int retval;
> > +
> > +     retval = tsnep_phy_open(adapter);
> > +     if (retval)
> > +             return retval;
> > +
> > +     for (i = 0; i < adapter->num_tx_queues; i++) {
> > +             addr = adapter->addr + TSNEP_QUEUE(i);
> > +             retval = tsnep_tx_open(adapter, &adapter->tx[i], addr);
> > +             if (retval)
> > +                     goto tx_failed;
> > +     }
> > +     retval = netif_set_real_num_tx_queues(adapter->netdev,
> > +                                           adapter->num_tx_queues);
> > +     if (retval)
> > +             goto tx_failed;
> > +     for (i = 0; i < adapter->num_rx_queues; i++) {
> > +             addr = adapter->addr + TSNEP_QUEUE(i);
> > +             retval = tsnep_rx_open(adapter, &adapter->rx[i], addr);
> > +             if (retval)
> > +                     goto rx_failed;
> > +     }
> > +     retval = netif_set_real_num_rx_queues(adapter->netdev,
> > +                                           adapter->num_rx_queues);
> > +     if (retval)
> > +             goto rx_failed;
> > +
> > +     netif_napi_add(adapter->netdev, &adapter->napi, tsnep_rx_napi_poll, 64);
>
> I know that you only have support for 1 queue for now. But having
> "tx[0]" and "rx[0]" hardcoded in tsnep_rx_napi_poll() seems less than
> ideal if you want to support more queues in the future.
>
> And I think that moving 'struct napi_struct' to be closer to the queues
> now will help make that future transition to multiqueue to be cleaner.

You are right, I will try to make it more multiqueue aware for future
transition.

> > +void tsnep_ethtool_self_test(struct net_device *netdev,
> > +                          struct ethtool_test *eth_test, u64 *data)
> > +{
> > +     struct tsnep_adapter *adapter = netdev_priv(netdev);
> > +
> > +     eth_test->len = TSNEP_TEST_COUNT;
> > +
> > +     if (eth_test->flags != ETH_TEST_FL_OFFLINE) {
> > +             /* no tests are done online */
> > +             data[TSNEP_TEST_ENABLE] = 0;
> > +             data[TSNEP_TEST_TAPRIO] = 0;
> > +             data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
> > +             data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
> > +
> > +             return;
> > +     }
> > +
> > +     if (tsnep_test_gc_enable(adapter)) {
> > +             data[TSNEP_TEST_ENABLE] = 0;
> > +     } else {
> > +             eth_test->flags |= ETH_TEST_FL_FAILED;
> > +             data[TSNEP_TEST_ENABLE] = 1;
> > +     }
> > +
> > +     if (tsnep_test_taprio(adapter)) {
> > +             data[TSNEP_TEST_TAPRIO] = 0;
> > +     } else {
> > +             eth_test->flags |= ETH_TEST_FL_FAILED;
> > +             data[TSNEP_TEST_TAPRIO] = 1;
> > +     }
> > +
> > +     if (tsnep_test_taprio_change(adapter)) {
> > +             data[TSNEP_TEST_TAPRIO_CHANGE] = 0;
> > +     } else {
> > +             eth_test->flags |= ETH_TEST_FL_FAILED;
> > +             data[TSNEP_TEST_TAPRIO_CHANGE] = 1;
> > +     }
> > +
> > +     if (tsnep_test_taprio_extension(adapter)) {
> > +             data[TSNEP_TEST_TAPRIO_EXTENSION] = 0;
> > +     } else {
> > +             eth_test->flags |= ETH_TEST_FL_FAILED;
> > +             data[TSNEP_TEST_TAPRIO_EXTENSION] = 1;
> > +     }
> > +}
>
> I liked these tests :-)

Thank you! TAPRIO/IEEE802.1Qbv support was challenging for me and these
tests helped me a lot. My goal was hardware support reduced to the minimum
and error prone calculation/switching stuff done by software.

Gerhard
