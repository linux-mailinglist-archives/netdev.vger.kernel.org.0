Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4072666A6
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgIKRah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIKRaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:30:30 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF9AC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:30:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr14so14858162ejb.1
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+opnVsqddqjBNOmcC1W89DwYfJmqmNaXaXHIwc35AsE=;
        b=PM8iB2GIN283nOfx6vIELSdGahbjatKOzl6XTs5OZtkMJ6+9E3C1AB+9baetmzfarl
         xupI09FTAn3pdW7DaI0JeTKLjsEet5KhKRZn15BBIIyan7n6KZMIuP1sjx5E9yo1ny4h
         4U/hgVvMr+vVktxkkqG7lwCQiuX/3HkrQT/c/g9F+nIyMRF6g5N9kKU6zfexCmzi+Xaw
         nG1+7vy9B1ifkdC+ZiIFgFCYDYZe6drpHbLTCARaEUw5KkkQovTBCnIWjKX2flVpJXwK
         9a6DOCEGGxmg6wvdiWR5LiH2jIm48dmXVJRu0VBqI+m/khYHt/iI6MykqCCTqHXwONRj
         aI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+opnVsqddqjBNOmcC1W89DwYfJmqmNaXaXHIwc35AsE=;
        b=jE3pLEY/QyisnvxDJci+SG5B069Q15u5OAfCAmLEhJFrVGmXYcii27dkpyGwv9tP/0
         JQMMqxGLO2GWNNU8mvh7ZJiLjdFP+o2pOp/yoX0fZPP0ufFWur79JsDgDgNydWZSkhDE
         rdRP2K6gEMPpLFJu5xVaZJtdy4nJhuWOScL2cXeNZCm60F6JiNzcUCV9jHScmmGyCKkO
         sS57RN84+YqUSz2SYKm2FvKsVwkrWyQp0LGTFOozerky43I1EG1XN6sKfB7DbU1cCj2M
         6gszexQ3fUQ+uSyKkKXZ87cFKclKgbi/Pc2kC6FMnW5loAciqVu7+6OdkIZ67ezTI7OX
         rV2w==
X-Gm-Message-State: AOAM531qsv21kg37HiPl3jZVd7WpMxmB8/j2oQhhIitY6KZ805aAU7FL
        MTbDLdgYs+newQkPQd8SslA=
X-Google-Smtp-Source: ABdhPJy0HtfVlMKRFh1F1imTZv5DhghANobWndT7MprFRC40IJHBdOPNd1hl9BwW/AohhKjHjxKCXQ==
X-Received: by 2002:a17:906:49c6:: with SMTP id w6mr2959380ejv.445.1599845428804;
        Fri, 11 Sep 2020 10:30:28 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id 16sm2237628edx.72.2020.09.11.10.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 10:30:28 -0700 (PDT)
Date:   Fri, 11 Sep 2020 20:30:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] Revert "net: dsa: Add more convenient
 functions for installing port VLANs"
Message-ID: <20200911173026.rsjiqquhrue2viio@skbuf>
References: <20200910164857.1221202-1-olteanv@gmail.com>
 <20200910164857.1221202-5-olteanv@gmail.com>
 <179dfb0e-60d5-5f49-7361-32cd57edd670@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179dfb0e-60d5-5f49-7361-32cd57edd670@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:52:03PM -0700, Florian Fainelli wrote:
> On 9/10/2020 9:48 AM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This reverts commit 314f76d7a68bab0516aa52877944e6aacfa0fc3f.
> >
> > Citing that commit message, the call graph was:
> >
> >      dsa_slave_vlan_rx_add_vid   dsa_port_setup_8021q_tagging
> >                  |                        |
> >                  |                        |
> >                  |          +-------------+
> >                  |          |
> >                  v          v
> >                 dsa_port_vid_add      dsa_slave_port_obj_add
> >                        |                         |
> >                        +-------+         +-------+
> >                                |         |
> >                                v         v
> >                             dsa_port_vlan_add
> >
> > Now that tag_8021q has its own ops structure, it no longer relies on
> > dsa_port_vid_add, and therefore on the dsa_switch_ops to install its
> > VLANs.
> >
> > So dsa_port_vid_add now only has one single caller. So we can simplify
> > the call graph to what it was before, aka:
> >
> >          dsa_slave_vlan_rx_add_vid     dsa_slave_port_obj_add
> >                        |                         |
> >                        +-------+         +-------+
> >                                |         |
> >                                v         v
> >                             dsa_port_vlan_add
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> I would be keen on keeping this function just because it encapsulates the
> details of creating the switchdev object and it may be useful to add
> additional functionality later on (like the DSA master RX VLAN filtering?),
> but would not object to its removal if others disagree.
> --
> Florian

Hmm, I don't think there's a lot of value in having it, it's confusing
to have such a layered call stack, and it shouldn't be an exported
symbol any longer in any case.
Also, I already have a patch that calls vlan_vid_add(master) and having
this dsa_port_vid_add() helper doesn't save much at all.

Thanks,
-Vladimir
