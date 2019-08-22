Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD2999E73
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389020AbfHVSJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:09:08 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38724 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731093AbfHVSJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:09:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0rWC-0005U2-7V; Thu, 22 Aug 2019 20:09:04 +0200
Message-ID: <0246f72cd9de2b72a54d0b7d8a733be4b36d05ef.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: add NL80211_CMD_UPDATE_FT_IES to supported
 commands
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>,
        Matthew Wang <matthewmwang@chromium.org>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 22 Aug 2019 20:08:59 +0200
In-Reply-To: <20190822180737.GA177276@google.com> (sfid-20190822_200743_384799_FF7227F8)
References: <20190822174806.2954-1-matthewmwang@chromium.org>
         <20190822180737.GA177276@google.com> (sfid-20190822_200743_384799_FF7227F8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-22 at 11:07 -0700, Brian Norris wrote:
> On Thu, Aug 22, 2019 at 10:48:06AM -0700, Matthew Wang wrote:
> > Add NL80211_CMD_UPDATE_FT_IES to supported commands. In mac80211 drivers,
> > this can be implemented via existing NL80211_CMD_AUTHENTICATE and
> > NL80211_ATTR_IE, but non-mac80211 drivers have a separate command for
> > this. A driver supports FT if it either is mac80211 or supports this
> > command.
> > 
> > Signed-off-by: Matthew Wang <matthewmwang@chromium.org>
> 
> FWIW:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
> > Change-Id: I93e3d09a6d949466d1aea48bff2c3ad862edccc6
> 
> Oops :)

:)

No worries, I can edit that out.

johannes

