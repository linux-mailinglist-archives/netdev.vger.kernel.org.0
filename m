Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A516B183AE1
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCLUvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgCLUvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:51:08 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAA6F206B7;
        Thu, 12 Mar 2020 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584046268;
        bh=iCGu/BoYFT4fYBgNra20OKuoQaUn/iE8IAIw27e9SPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zHgSqtT+5DlNJnfciYf9zd0LqPRRMuIUY6dAhg2WkQwWt9yPHlXRVpQtkaBPY/aNW
         EeYreg0HO5bXxUJAVt6OPtECfA7Wie9/bXg2p2lri/w1dAno5aAL9shFoJOUBDSw1+
         RK6JK2cqJ5jEl84Mtii3IlUV9rwqNZFcThLnzYM4=
Date:   Thu, 12 Mar 2020 13:51:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 13/15] ethtool: provide channel counts with
 CHANNELS_GET request
Message-ID: <20200312135106.6868009e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <94c8eef601034d8f7409a760479e472e506c3ea7.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
        <94c8eef601034d8f7409a760479e472e506c3ea7.1584043144.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 21:08:38 +0100 (CET) Michal Kubecek wrote:
> Implement CHANNELS_GET request to get channel counts of a network device.
> These are traditionally available via ETHTOOL_GCHANNELS ioctl request.
> 
> Omit attributes for channel types which are not supported by driver or
> device (zero reported for maximum).
> 
> v2: (all suggested by Jakub Kicinski)
>   - minor cleanup in channels_prepare_data()
>   - more descriptive channels_reply_size()
>   - omit attributes with zero max count
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
