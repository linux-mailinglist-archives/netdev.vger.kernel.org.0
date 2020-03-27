Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7DE195DFB
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgC0S4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:56:17 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:52873 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0S4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:56:17 -0400
Received: by mail-pj1-f51.google.com with SMTP id ng8so4245025pjb.2;
        Fri, 27 Mar 2020 11:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mc4gnjwv+NorZuWShLTClne9UWocZJwmdrYE9fdLcqs=;
        b=Re/P2YH7XsvR4J+PRByySEn5OTMEInkf2SrhInM49wks3p/bGpkY4luWBvfcZmOa+M
         08XTHEldC2fYcprxAF327MyzpxHLD96jmWjpNF0JAYvUJ/Yc2QQqI51kjJrOt4wDMkQR
         9Fb/DwDiAV8nXY0DqhfUM/vfVhEKwLSX3A1MdIIW7sQzOs9/YGm+uskbewpjPiIdy4v/
         lCs9B/mIKAwptV3mWlinXD7VR1AXnCHUwtBJYHGv+cBxpLXVuSL98R0mRKuXshOrawdU
         iA7IyKb3CwcV9VPKspEdXxxrlavSYGzCXNK2OJbfMeiBNKDSvpAEH8gY6ULN8AXyyKvJ
         K+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mc4gnjwv+NorZuWShLTClne9UWocZJwmdrYE9fdLcqs=;
        b=B1YtrWHf5EjHjs2mfwIjwAgvxdOe4EeMqb3RLHqxwnG7RuWZ0uKgWscLyS3tsAQMCp
         WdB9J7rW7IsT7Kg7jnOSXhWZ6uu7oPzHSiDRbH7NbWIibmbVl/WmywOYLLFhqK7V2+Iw
         nsP4AHDoQSNCjF9L+G4AvW4hZEoxCNbCn3X/8BC+8iP3pUs1fmD/RDXyxVAg79CJP1za
         qBkcOJa/NiXe7Fwq7bP0PnPBYlZ6yBd+md93ffXH0AJwlfChUoQIAGWR7rGeph/kH2Nq
         rnAz+f05YotYeqxfzj3fdxAeI2bSF9Zyedn0aLHUQcDSEt22oOrqaDhSgeSW2a/jxCsk
         YRDw==
X-Gm-Message-State: ANhLgQ0vxsqx+hC+rrR2+3tQu52DDb1JJL1YSzivCZ5mbulTHDD9MPNy
        5yOlOTateKst82iEn73gnkZ2+2n3
X-Google-Smtp-Source: ADFU+vt1wa+jcH3CbuTaPOaz1kYZpblawTT3hlHlCpr1TeHjUNg/811xk6GEw/fHDs8oWaj9zW8vgQ==
X-Received: by 2002:a17:90a:fd90:: with SMTP id cx16mr898109pjb.41.1585335375600;
        Fri, 27 Mar 2020 11:56:15 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x188sm4784948pfx.198.2020.03.27.11.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 11:56:15 -0700 (PDT)
Date:   Fri, 27 Mar 2020 11:56:13 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/12] ethtool: provide timestamping
 information with TIMESTAMP_GET request
Message-ID: <20200327185613.GB28023@localhost>
References: <cover.1585316159.git.mkubecek@suse.cz>
 <5a3af8d892cafe9d9a2dc367e9ae463691261305.1585316159.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a3af8d892cafe9d9a2dc367e9ae463691261305.1585316159.git.mkubecek@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 03:08:17PM +0100, Michal Kubecek wrote:
> +/* TIMESTAMP */
> +
> +enum {
> +	ETHTOOL_A_TIMESTAMP_UNSPEC,

I suggest using ETHTOOL_A_TSINFO_ throughout.  After all, this API
does not provide time stamps, and we want to avoid confusion.

> +	ETHTOOL_A_TIMESTAMP_HEADER,			/* nest - _A_HEADER_* */
> +	ETHTOOL_A_TIMESTAMP_TIMESTAMPING,		/* bitset */
> +	ETHTOOL_A_TIMESTAMP_TX_TYPES,			/* bitset */
> +	ETHTOOL_A_TIMESTAMP_RX_FILTERS,			/* bitset */
> +	ETHTOOL_A_TIMESTAMP_PHC_INDEX,			/* u32 */
> +
> +	/* add new constants above here */
> +	__ETHTOOL_A_TIMESTAMP_CNT,
> +	ETHTOOL_A_TIMESTAMP_MAX = (__ETHTOOL_A_TIMESTAMP_CNT - 1)
> +};

Acked-by: Richard Cochran <richardcochran@gmail.com>
