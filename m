Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998F139B504
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFDIks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:40:48 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:44007 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhFDIkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:40:47 -0400
Received: (Authenticated sender: hadess@hadess.net)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id DFDCB10000B;
        Fri,  4 Jun 2021 08:38:57 +0000 (UTC)
Message-ID: <fc36d07a8f148a45c61225fefdd440313ee723d0.camel@hadess.net>
Subject: Re: [PATCH v3 1/3] Bluetooth: use inclusive language in HCI role
 comments
From:   Bastien Nocera <hadess@hadess.net>
To:     Archie Pusaka <apusaka@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 04 Jun 2021 10:38:57 +0200
In-Reply-To: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
References: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-04 at 16:26 +0800, Archie Pusaka wrote:
> 
> The #define preprocessor terms are unchanged for now to not disturb
> dependent APIs.

Could we add new defines, and deprecate the old ones? Something akin
to that would help migrate the constants, over time:
https://gitlab.gnome.org/GNOME/glib/blob/master/glib/gmacros.h#L686-716

