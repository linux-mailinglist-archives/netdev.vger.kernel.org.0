Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD8229B5C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732870AbgGVP1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732648AbgGVP1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:27:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF30C0619DE
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:27:50 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so1460750pgq.1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BU5kao+UrN6qaCFLRvgX1CCWwHi4WqVglmjspXYq5Sk=;
        b=EovH3VlzCQtsuc+av4WNCxJUcxJwP7B12FigkxGwdbpkWBJSa3nFzmdyDHewZBUgf9
         n9XAAbimkyD6gzI4ZP5yddnLgDay1H3s8JWoHuKzSxSnwrCDbkxcwIVY/juKY/c9O6eu
         /OJSCysVhxcaeiqedSqEFceKVfg/12GZLPjr8pz1XHtNHTXpeFGbtjZFu3+roMJb796i
         BBnMW3Am+YU+1yDNm3kWRfcRFBtPlDgDBFvjGBggj1IU6U2AeUKKCFIvvGVB0VJDmGAM
         OReaUOEwz/0BPPxzQZFG4OMdZ6z6W9/XcwI4LsFf0nnHHUL9iPyaLIxuLhiXMi9xOuXE
         S9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BU5kao+UrN6qaCFLRvgX1CCWwHi4WqVglmjspXYq5Sk=;
        b=BrHctE2z6Dl8SdceyoDeMa9RC/zDdX84N9hn6ZtOWPaIXEs0rMjgyJpdQU7iUFUFhU
         zgo5+8S7MQGiV7xn13uUin6x7tv5TtaWb9JLUBGjA7U3O4jwv+MymU7TfPxNUQhnTkeZ
         bHXY3wgULauaX++9eUzxnNJZXUSFCh02NAs5ergwQg+eQedE10seJEvyh7njndKUQN28
         tG3LHJ06/0dvS8PqpyRofXayjjanVRPUHeIk+zR0vb/J0QPwGXa9mlWelbZf2juk6OOj
         18J2I3ElXFYsVG5QyLtqNxzhG1bWlTv/96DwX/sJzTNZgkB158x3qAirvBHHfpyxyg1h
         0MAw==
X-Gm-Message-State: AOAM5326W+h+JilkR1LP4DaxzoIqGiPkUZ/OBTyAXHb9b0k0XJH6aSC/
        HOu2f01EokkuNDS2lhwg+CafWQ==
X-Google-Smtp-Source: ABdhPJz7gxZddqXP9qDdhZYE/mLuRzLNI5tYgqcLfKtMO+PIAiD+BS9SLWN/x3TbHpXr660AUHbyWg==
X-Received: by 2002:a63:8c4f:: with SMTP id q15mr317114pgn.373.1595431670305;
        Wed, 22 Jul 2020 08:27:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h23sm173554pfo.166.2020.07.22.08.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 08:27:49 -0700 (PDT)
Date:   Wed, 22 Jul 2020 08:27:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     wangxiongfeng2@huawei.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net-sysfs: add a newline when printing 'tx_timeout'
 by sysfs
Message-ID: <20200722082741.1675d611@hermes.lan>
In-Reply-To: <20200721.153632.1416164807029507588.davem@davemloft.net>
References: <1595314977-57991-1-git-send-email-wangxiongfeng2@huawei.com>
        <20200721.153632.1416164807029507588.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 15:36:32 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Date: Tue, 21 Jul 2020 15:02:57 +0800
> 
> > When I cat 'tx_timeout' by sysfs, it displays as follows. It's better to
> > add a newline for easy reading.
> > 
> > root@syzkaller:~# cat /sys/devices/virtual/net/lo/queues/tx-0/tx_timeout
> > 0root@syzkaller:~#
> > 
> > Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>  
> 
> Applied, thank you.

Could you add


Fixes: ccf5ff69fbbd ("net: new counter for tx_timeout errors in sysfs")
Cc: david.decotigny@google.com
