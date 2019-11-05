Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6ECEF6D1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388072AbfKEIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:06:02 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:43749 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388030AbfKEIGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:06:01 -0500
Received: from gandi.net (laubervilliers-658-1-215-187.w90-63.abo.wanadoo.fr [90.63.246.187])
        (Authenticated sender: thibaut.sautereau@clip-os.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 3CD66240008;
        Tue,  5 Nov 2019 08:05:54 +0000 (UTC)
Date:   Tue, 5 Nov 2019 09:05:54 +0100
From:   Thibaut Sautereau <thibaut.sautereau@clip-os.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
Subject: Re: Double free of struct sk_buff reported by
 SLAB_CONSISTENCY_CHECKS with init_on_free
Message-ID: <20191105080554.GA1006@gandi.net>
References: <20191104170303.GA50361@gandi.net>
 <719eebd3-259d-8beb-025a-f2d17c632711@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <719eebd3-259d-8beb-025a-f2d17c632711@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 09:33:18AM -0800, Eric Dumazet wrote:
> 
> 
> On 11/4/19 9:03 AM, Thibaut Sautereau wrote:
> > 
> > We first encountered this issue under huge network traffic (system image
> > download), and I was able to reproduce by simply sending a big packet
> > with `ping -s 65507 <ip>`, which crashes the kernel every single time.
> > 
> 
> Since you have a repro, could you start a bisection ?

From my previous email:

	"Bisection points to the following commit: 1b7e816fc80e ("mm: slub:
	Fix slab walking for init_on_free"), and indeed the BUG is not
	triggered when init_on_free is disabled."

Or are you meaning something else?

-- 
Thibaut Sautereau
CLIP OS developer
