Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A57D2F59
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfJJRNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:13:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:47952 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfJJRNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 13:13:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7B03B061;
        Thu, 10 Oct 2019 17:13:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 14DB1E378C; Thu, 10 Oct 2019 19:13:07 +0200 (CEST)
Date:   Thu, 10 Oct 2019 19:13:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 05/17] ethtool: helper functions for netlink
 interface
Message-ID: <20191010171307.GC22163@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <061af34c9f34205ed18a126cef9ebe1534de8bc7.1570654310.git.mkubecek@suse.cz>
 <20191010134203.GA22798@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010134203.GA22798@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 03:42:03PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:15PM CEST, mkubecek@suse.cz wrote:
> 
> [...]
> 
> 
> >+/**
> >+ * ethnl_parse_header() - parse request header
> >+ * @req_info:    structure to put results into
> >+ * @header:      nest attribute with request header
> >+ * @net:         request netns
> >+ * @extack:      netlink extack for error reporting
> >+ * @policy:      netlink attribute policy to validate header; use
> >+ *               @dflt_header_policy (all attributes allowed) if null
> >+ * @require_dev: fail if no device identiified in header
> 
> s/identiified/identified/

Will fix.

Michal
