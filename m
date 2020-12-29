Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687A62E70A4
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 13:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL2MbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 07:31:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:59116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgL2MbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 07:31:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1609245035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXIBw1ycePVQvHAbHxwndaG5kIVWvKnE3XER9JANhjw=;
        b=axio+OHxFd8luTm8ve7TC+4iAHhTxAbMeiWontp9D9gTi1+XOHd0oUY8dO/o4KAddyBgXG
        i55fXblb1bUjlqwGyGO0gXnB/dVQ3JUBN4My12lVXKVxg00yeN3fbgqkOmzLCiUw0NL0Dt
        k/pJ2UKuS/6MjcGkUuSuWPJgtWI3r90=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D9B6AE66;
        Tue, 29 Dec 2020 12:30:35 +0000 (UTC)
Message-ID: <f22ac6bdf5560a4fefc5b931e7451f503fc6cfcb.camel@suse.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
From:   Oliver Neukum <oneukum@suse.com>
To:     Roland Dreier <roland@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Tue, 29 Dec 2020 13:30:34 +0100
In-Reply-To: <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
         <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 28.12.2020, 23:56 -0800 schrieb Roland Dreier:
> > Applied to net and queued for LTS, thanks!
> 
> Thanks - is Oliver's series of 3 patches that get rid of the other
> half of the log spam also on the way upstream?

Hi,

I looked at them again and found that there is a way to get
the same effect that will make maintenance easier in the long run.
Could I send them to you later this week for testing?

	Regards
		Oliver



