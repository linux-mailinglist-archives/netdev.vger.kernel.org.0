Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154B61A2A0A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgDHUDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:03:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgDHUDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:03:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C5A57127BE398;
        Wed,  8 Apr 2020 13:03:30 -0700 (PDT)
Date:   Wed, 08 Apr 2020 13:03:29 -0700 (PDT)
Message-Id: <20200408.130329.295853466281180903.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] fw upgrade filter fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200408161912.17153-1-snelson@pensando.io>
References: <20200408161912.17153-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Apr 2020 13:03:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed,  8 Apr 2020 09:19:10 -0700

> With further testing of the fw-upgrade operations we found a
> couple of issues that needed to be cleaned up:
>  - the filters other than the base MAC address need to be
>    reinstated into the device
>  - we don't need to remove the station MAC filter if it
>    isn't changing from a previous MAC filter

Series applied, thank you.
