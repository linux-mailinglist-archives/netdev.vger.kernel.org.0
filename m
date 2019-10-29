Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60952E8EE2
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbfJ2SAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:00:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40655 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727379AbfJ2SAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:00:15 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1iPVmu-0002za-1h; Tue, 29 Oct 2019 14:00:12 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x9THsGfa024926;
        Tue, 29 Oct 2019 13:54:16 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x9THsGr7024925;
        Tue, 29 Oct 2019 13:54:16 -0400
Date:   Tue, 29 Oct 2019 13:54:16 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>
Subject: Re: Bunch of compiler warning fixes for ethtool.
Message-ID: <20191029175416.GA8296@tuxdriver.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 09:35:02PM -0700, Maciej Żenczykowski wrote:
> You can merge them via:
>   git fetch https://github.com/zenczykowski/ethtool.git fix-warnings
>   git merge FETCH_HEAD
> 
> and I'll follow up this email with the full set.

Thanks -- queued for next release...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
