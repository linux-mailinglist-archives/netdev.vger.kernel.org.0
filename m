Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3EB43D1BE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbhJ0Tgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238347AbhJ0Tgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:36:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26E4C60EFE;
        Wed, 27 Oct 2021 19:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635363249;
        bh=N8Chnx5kfJxDqUUPAAoayt+Y/WYX5AYcF/Jbr1LMsZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t56KgNvcJ0NKDEY+tz/LRKzjq9RDV0W/mI2pZ+z1GSbT6eRQHX09ZAMXRo4XTViuC
         7Bdg+gaFZRN3mhSOGCL0f5zAO9nI0VT2EdYNByHZGMAlWsi9YfYR3XGCmgKiAJjOXo
         e+pHfSEOm0uooh5CEqAYc7ViXcUIUxxp6B/o0MPSRn6oUQ9nZBoaVUJq0BZAd1MM0l
         lysEqZ+xFk/aJOk6gPxabzW1bBsqBUiR2YlDkn5iRDuun0AzhiHEwGdI8sz035D7tn
         Z/pyysPgIydntua7jeayPLHn27pEcy3YmOGzHxF5eShhjcLTosb5B4KFpTG2UNg2G4
         BwmHWT5xKZhog==
Date:   Wed, 27 Oct 2021 12:34:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>,
        John 'Warthog9' Hawley <warthog19@eaglescrag.net>
Cc:     Slade Watkins <slade@sladewatkins.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: Unsubscription Incident
Message-ID: <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
        <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
        <YXY15jCBCAgB88uT@d3>
        <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
        <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 11:34:28 -0700 Shannon Nelson wrote:
> >> It happened to a bunch of people on gmail:
> >> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u  
> > I can at least confirm that this didn't happen to me on my hosted
> > Gmail through Google Workspace. Could be wrong, but it seems isolated
> > to normal @gmail.com accounts.
> >
> > Best,
> >               -slade  
> 
> Alternatively, I can confirm that my pensando.io address through gmail 
> was affected until I re-subscribed.

Did it just work after re-subscribing again? Without cleaning the inbox?
John indicated off list that Gmail started returning errors related to
quota, no idea what that translates to in reality maybe they added some
heuristic on too many emails from one source?
