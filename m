Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4077D2313B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgG1UQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgG1UQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:16:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBFC920656;
        Tue, 28 Jul 2020 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595967415;
        bh=EghmSa8VsIxvC899mGbrzLAjG2kcgrSLmjU7bARJJ/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyJCkIrVuZ4vb9rhatxLUve34oZADiPY4mpLIIyuD9mrw1KNqIVBSrwM8Qg42mepb
         odeikbldj4fFfMMB+hRow25LAoSn8U7jPGHg0/87W8cOhxH90mwMsH+1z7wnMpNzsc
         L46uA8LO9Mf2fSMe6YktLM8QuDgLPcAKxhG8Om80=
Date:   Tue, 28 Jul 2020 13:16:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com
Subject: Re: [net-next 0/6][pull request] 40GbE Intel Wired LAN Driver
 Updates 2020-07-28
Message-ID: <20200728131653.3b90336b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 12:08:36 -0700 Tony Nguyen wrote:
> This series contains updates to i40e driver only.
>=20
> Li RongQing removes binding affinity mask to a fixed CPU and sets
> prefetch of Rx buffer page to occur conditionally.
>=20
> Bj=C3=B6rn provides AF_XDP performance improvements by not prefetching HW
> descriptors, using 16 byte descriptors, increasing budget for AF_XDP
> receive, and moving buffer allocation out of Rx processing loop.

My comment on patch #2 is really a nit, but for patch 5 I think we
should consider carefully a common path rather than "tweak" the drivers
like this.
