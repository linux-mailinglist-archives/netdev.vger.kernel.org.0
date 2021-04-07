Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB2357895
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhDGXeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDGXeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:34:15 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B710C061760;
        Wed,  7 Apr 2021 16:34:05 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e14so30387421ejz.11;
        Wed, 07 Apr 2021 16:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8y9JU+OMWYalGasFf8vmWs+F/CG7kz1ojiAfXE2LEE=;
        b=YEIii84ZgqFaDJ6O6avTbFwY0FPK4iqqUdqRTWZMPltwz9agyCh4XrUUXT9pCnn/PN
         zwm4hT3Oi+kWTaERPFMHpOw9Cn2ktfC0dCL3jHfU1GTfb/Bckg2Ho6Y5qNBvMUgVHRre
         Ea2EFojrNzQAZGMRWaWlu+uT83tfbPKqjr7+alnmPAXn15Tg1XT4I66cBWBA3Q7B00TW
         +ix+qJGw5GnrjSLSlBONqHpKr3e9/zW3BZ7t7WhKOAyVf+tYvcaIjuGTT508/MDzdNqm
         BuogKu4k6ImcZGLHn7jjWS+bTbDWpMrywH2SeychA3WkupEa1/Wgnfy2Oe6DzHcsGfwC
         ofxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8y9JU+OMWYalGasFf8vmWs+F/CG7kz1ojiAfXE2LEE=;
        b=ba6Y/vHzsS5jzfI7wDHsN2ayHA0MWL4hoe5hes0ZyYPG+pcSHXUHFOYB/dGDTJLRXp
         TcT11+xwoIthDbDlsap0GNMVCfqL7Io1NSmkYgdJT3mrdkHvQ7FW7DjLXoKWybiWDwQc
         2ZzehyzH/UObxN/qv7edDRrHUwLn+VB1/CicYK5Jd8Uz9U9qqCqRJNVe9dSSEu59jo0W
         I0vfeGNyZKbBbCJH7ZZI2CP2E/nM2HTsgsi2yX0YPNd7N6PGb+yy+1Fc56xNZvs/J1kY
         Dd3XmQMlz2ibMzPyOKXHLcJ+fJyyJCD47P+n2wz+1vQvZt/EWf07gyNkblHfujb3KCnE
         a5YA==
X-Gm-Message-State: AOAM531jfIOAgXo7iR5df68+yblwGQCzbaE2VnBHp6nZvCT+sTTf9OAf
        X9IGZRwmyRczLRedbJcrjaw=
X-Google-Smtp-Source: ABdhPJxBhOd3cU5LLcbUanZLye0PrFiEha8pADAf8CQgjK7iyTZbK5/UEdjU28vzw0bB51ldt9/v/g==
X-Received: by 2002:a17:906:9882:: with SMTP id zc2mr6624415ejb.441.1617838443575;
        Wed, 07 Apr 2021 16:34:03 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y21sm8396059edv.31.2021.04.07.16.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:34:03 -0700 (PDT)
Date:   Thu, 8 Apr 2021 02:34:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Rob Herring <robh@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: Document
 dsa,tag-protocol property
Message-ID: <20210407233402.sjuygy35imokeslz@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-4-tobias@waldekranz.com>
 <20210327181343.GA339863@robh.at.kernel.org>
 <87blarloyi.fsf@waldekranz.com>
 <YGxihuL2T12HKso1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGxihuL2T12HKso1@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 03:30:46PM +0200, Andrew Lunn wrote:
> > Andrew, Vladimir: I will just list dsa and edsa for now. If it is needed
> > on other devices, people can add them to the list after they have tested
> > their drivers. Fair?
> 
> O.K.

Same here.
