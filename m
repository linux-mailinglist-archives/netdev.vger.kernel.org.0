Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195B13256C2
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhBYTcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbhBYTa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:30:27 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D65C06178C
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:29:46 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id h4so7634601ljl.0
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=/MS/iesMlWSJUXY0OjfZoCCQVAqIww1fj51YA1dirL0=;
        b=mabfdgYmnHhsywfDCy5GQq6iwVfICqIRcZ3EijPDKc5qpSpNwWPP/YLms+VRbbSZoV
         0YnlGqbRBRZjwQg+kaGi7m6z43EcCP9ag1Lqr3atSh+uxeH1UEM8iC3RP/GDEup+oAJs
         23/ZFLVjbltp1M+gpmGQd0qMgK0FRoo6YJjS5TBVYJh9SnCtum+6rwUgqcvC9rJ2IQo/
         MjTf6WfzHA6PxeXSjfDXbBG3GRMIaRr9l9J4YBhT4yWqcTy8yt75bSss49CB5nHQfgkp
         OllASsNOzLz5tg/Wm/SAAprSHmOBzDBcpIkQN/dUACNOizUuxihSJ9IxtINNgcBySrno
         DtHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/MS/iesMlWSJUXY0OjfZoCCQVAqIww1fj51YA1dirL0=;
        b=LJXZKYzYRaoHPADdoic3gMnXqlsBP5zlsy8O9bNqYfrubElgn5MdZUvB8lrXl9PqUW
         hvU8C+7AIYAgAIuGliqSajLakLoVWvnJOA3kjdKv1QlgZr7s+u/h8ChLozq+B2vFnvxI
         zP2KgCbOTomON6G1pSBXn6lorDF+MDcBq86Cb1gFX9D7xpboGWypUPxvZef6c9a0y3Bm
         xniuIatR3FQhmfVQ3mqSu+b0K9gMnJws0xRg0/rgswEwvSNwtz79iXMN8/h+pQDI6som
         kQqiC2Dkv4KY6iCPLelVkI8ZBVf7LpX/A8IlGP+3744dydDF2MNMVo3zV8TCsGlp2PZv
         fhWw==
X-Gm-Message-State: AOAM532oSNakRorQgAZADEb5n9zm7F5wPd1GOHiBgJfffeEOhaBNc5fc
        JfkOaZYcj4kCfQ2siCb7dCG62g==
X-Google-Smtp-Source: ABdhPJxPFSsStx87MjYL2RBjZ2lt/Pi30/jlK/g6gogzt9oL8BYJs4u9y3soRcILX7JL3rc+WRD11g==
X-Received: by 2002:a2e:584b:: with SMTP id x11mr2272556ljd.421.1614281385313;
        Thu, 25 Feb 2021 11:29:45 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id v80sm1175232lfa.229.2021.02.25.11.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:29:44 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 01/12] Documentation: networking: update the graphical representation
In-Reply-To: <20210221213355.1241450-2-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com> <20210221213355.1241450-2-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 20:29:43 +0100
Message-ID: <871rd4rlnc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 21, 2021 at 23:33, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> While preparing some slides for a customer presentation, I found the
> existing high-level view to be a bit confusing, so I modified it a
> little bit.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
