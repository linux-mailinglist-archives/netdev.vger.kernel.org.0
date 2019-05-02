Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02C122A8
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 21:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEBToT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 15:44:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58288 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBToT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 15:44:19 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DECF51340AD62;
        Thu,  2 May 2019 12:44:17 -0700 (PDT)
Date:   Thu, 02 May 2019 15:44:14 -0400 (EDT)
Message-Id: <20190502.154414.1321655139720401692.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 00/12] NXP SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
        <20190430.234425.732219702361005278.davem@davemloft.net>
        <CA+h21hrmXaAAepTrY-HfbrmZPVRf3Qg1-fA8EW4prwSkrGYogQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 May 2019 12:44:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 2 May 2019 19:31:50 +0300

> Do you know what causes these whitespace errors, so I can avoid them
> next time?

Your files have empty lines at the end of the file.

Simply remove those trialing empty lines.
