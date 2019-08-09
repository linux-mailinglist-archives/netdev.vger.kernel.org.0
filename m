Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679B587FFE
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437158AbfHIQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:30:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39774 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437155AbfHIQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:30:13 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hw7mN-00030i-JT; Fri, 09 Aug 2019 12:30:11 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x79GLKDY008039;
        Fri, 9 Aug 2019 12:21:20 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x79GLJuV008036;
        Fri, 9 Aug 2019 12:21:19 -0400
Date:   Fri, 9 Aug 2019 12:21:19 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] gitignore: ignore vim swapfiles and patches
Message-ID: <20190809162119.GA8016@tuxdriver.com>
References: <20190729131003.1E301E0E3B@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729131003.1E301E0E3B@unicorn.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 03:10:03PM +0200, Michal Kubecek wrote:
> The .*.swp files are created by vim to hold the undo/redo log. Add them to
> .gitignore to prevent "git status" or "git gui" from showing them whenever
> some file is open in editor.
> 
> Add also *.patch to hide patches created by e.g. "git format-patch".
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Queued for next release...thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
