Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2CD5D986
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfGCAqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:46:45 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:37339 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGCAqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:46:45 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 20:46:45 EDT
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1hiSqn-0001mL-Up; Wed, 03 Jul 2019 02:10:18 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.92)
        (envelope-from <laforge@gnumonks.org>)
        id 1hiTlY-0003XJ-LX; Wed, 03 Jul 2019 09:08:56 +0800
Date:   Wed, 3 Jul 2019 09:08:56 +0800
From:   Harald Welte <laforge@gnumonks.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, pablo@netfilter.org,
        Pau Espin <pespin@sysmocom.de>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/6] gtp: fix several bugs
Message-ID: <20190703010856.GA11901@nataraja>
References: <20190702152034.22412-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702152034.22412-1-ap420073@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Taehee,

On Wed, Jul 03, 2019 at 12:20:34AM +0900, Taehee Yoo wrote:
> This patch series fixes several bugs in the gtp module.

thanks a lot for your patches, they are much appreciated.

They look valid to me after a brief initial review.

However, I'm currently on holidays and don't have the ability to test
any patches until my return on July 17.  Maybe Pablo and/or Pau can have
a look meanwhile?  Thanks in advance.

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
