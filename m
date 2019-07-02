Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C275CF06
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGBMDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:03:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39683 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfGBMDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:03:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so702008wma.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gm6GhJ7gb2LUevWRbLpcuyKEIGbt2fZGuGZRBRjtrqo=;
        b=bQ8Ccg7NMvFz5SZ6bdMtcHci+tw+AVpOAcAvig717mhKAU267n1pDLGerYlOyaF/l/
         GlxVJVT+q9H9/5/2WnKqW2xmPMzmC68pRIhvKQ/EuvGokbZ/6C065TC3eQxl65Eo433N
         ESC/7CWXCxK7A/UwMJJACnJ+qqKjOQEBvzcOKti2c5cm69YOZFf+QOhcXTi42Rk3nyTP
         vb5ZjqySvu9iQcU5U8uCRP6n7OuTXCsLy1UbM04HCVP5W3D+ornDtdGemnIcjNtwxff/
         +FJkcvuItvzJTuKIEAnnDGKT+bHuHgnAmKMSEB8mrfm9fgG5cnpON3IPIWj/PjCjsrvN
         ZbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gm6GhJ7gb2LUevWRbLpcuyKEIGbt2fZGuGZRBRjtrqo=;
        b=UiktGlpdp1G1aXtq8S7j6auD/Zkn06Kw3jxXE7BAwlYNVV/xY63MGA8aTfNH7HyMLC
         DCeFSZqAG2MO5OTVw6cx2+Vy5j4kaOjn+kjbdwHFRbqNkAMfDiD82z7xGLXDNft6WfP1
         0bRJoQL6GsJZs6yZJqeSZtrLJZvuGyVPrQ1z3aYyvHQtvYfcBp8T6gcNFThy7JCK3t8i
         Sx5mqNLb1KBd2DSCgeVAOstwJ/5yb7uTrkHeLNpH+AMs9EZaMYTv9W6t8c7eLUpqZjsI
         DuZWN8VscSFpxSmtI/FHHTbnQgNd/4XYktXaeAqnCR07xP+xxqbGjd7IEJd3KEVcVJLJ
         IQZA==
X-Gm-Message-State: APjAAAUNPu4xq7NIg4CMNNLwF/uu5SKg2w/dlgxMdppSFEbxr9nTja47
        eAfPaFHyhS94Bb0M0K+cZ/0=
X-Google-Smtp-Source: APXvYqzY1WIZXqGwqXvHrmdMUEorT4psdCq6z0c+xvUPrw4/kcZzicISqdSJdPPkYLHuIAf54uR9IQ==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr3351914wmg.7.1562069016717;
        Tue, 02 Jul 2019 05:03:36 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id y16sm10463591wru.28.2019.07.02.05.03.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:03:36 -0700 (PDT)
Date:   Tue, 2 Jul 2019 14:03:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 02/15] netlink: rename
 nl80211_validate_nested() to nla_validate_nested()
Message-ID: <20190702120335.GM2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <d0c23ac629c4a0343acc9f09484e078962c55402.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c23ac629c4a0343acc9f09484e078962c55402.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:49:49PM CEST, mkubecek@suse.cz wrote:
>Function nl80211_validate_nested() is not specific to nl80211, it's
>a counterpart to nla_validate_nested_deprecated() with strict validation.
>For consistency with other validation and parse functions, rename it to
>nla_validate_nested().
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Acked-by: Jiri Pirko <jiri@mellanox.com>
