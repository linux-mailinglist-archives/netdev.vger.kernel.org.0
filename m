Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75C1210B640
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfK0S5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:57:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0S5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:57:33 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A502B149C93F6;
        Wed, 27 Nov 2019 10:57:31 -0800 (PST)
Date:   Wed, 27 Nov 2019 10:57:31 -0800 (PST)
Message-Id: <20191127.105731.374218383792270881.davem@davemloft.net>
To:     po.liu@nxp.com
Cc:     hauke.mehrtens@intel.com, gregkh@linuxfoundation.org,
        allison@lohutok.net, tglx@linutronix.de, hkallweit1@gmail.com,
        saeedm@mellanox.com, andrew@lunn.ch, f.fainelli@gmail.com,
        alexandru.ardelean@analog.com, jiri@mellanox.com,
        ayal@mellanox.com, pablo@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, simon.horman@netronome.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 10:57:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, please repost this series when net-next opens back up.

Thank you.
