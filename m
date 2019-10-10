Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0853D2B45
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbfJJN1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:27:24 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43670 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387435AbfJJN1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 09:27:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so7882882wrq.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 06:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dmw9YKEnJH0xnP6XYOENSIFf2Gufm0ggzwL2mm2yafE=;
        b=DNzj9ZH+F8aL6u8qsrUX7J0cdlwFgbX0wW9nvvNfz4zFANyMQXP6nqi0yLZOO8pIB9
         8IUfdIbTuHb9pHU87XQchMA6cUoTxYDtmZvl3DNvTY25SK/J+UusfOmHUBVqs7Hqm83N
         hnk+koPYj26RyoeIMy+fj6NBs5CpCuQpmMuCaQUFx4MYktWEkl0dCN6TYdVLhG0dnj/a
         sFzcAJOsbn5IvoNI9zaVQecHDTlly2h0P47LR3Jb8Scg6FnH4Ygn8XrRM371Um3CVKHi
         PV9XeHKo9VkVL79XVXQ9a2nnt4a2Tqax3Gab+enTnEzYYQlwlutMD1ZmA9hsb0R3bHU7
         mBSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dmw9YKEnJH0xnP6XYOENSIFf2Gufm0ggzwL2mm2yafE=;
        b=kVrjY7Hj0wOEzadJj7+Fej+vX+xZ8vvRUP1u2+gXjRSDb8HMzXIAP3c/sVxzSBQbj/
         nnW28gXI4slKutVDS+ubxuPoZMh5s5RtPMrpYnV/euV9S+VHti/KWZebunGvof64WAhb
         pG0mgsCt7XK6VjW/P6didcfY1D5q5GTerx2ucBSEueI9wClADV72Q3/BnRwoGfE/w+sL
         btpsPDPQKUuPJLY0tXaNlYjdsxl9TzHzd7vrk6dTnpDST4UQe+fPG0FgStasWHLJ8Be5
         g1QgRL/q3aoX1WIXbDOhWQzedAqusR6lBifsZTxkbSMKVVH8kTr/6TyV2j5HTmcfOsgC
         Zlkg==
X-Gm-Message-State: APjAAAUPnyXoS27zobI3klLXvNnQGcXsBiAqYfa8TQey7Sdn1qPVYpkb
        elSHrkiacAWaSKuaCB/0+ek7/g==
X-Google-Smtp-Source: APXvYqzGdwXQ1iBRJr9T1jnAKNcxOv7mE40fUrtB/6oE8AlVXfXE5UfbgbM3jFrKLPhoMOpcQrXeqw==
X-Received: by 2002:adf:df81:: with SMTP id z1mr8747484wrl.367.1570714040743;
        Thu, 10 Oct 2019 06:27:20 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id 3sm6850086wmo.22.2019.10.10.06.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 06:27:20 -0700 (PDT)
Date:   Thu, 10 Oct 2019 15:27:19 +0200
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
Subject: Re: [PATCH net-next v7 08/17] ethtool: move string arrays into
 common file
Message-ID: <20191010132719.GI2223@nanopsycho>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <042003c76da65268f6205f42f96193d372819838.1570654310.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <042003c76da65268f6205f42f96193d372819838.1570654310.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 10:59:24PM CEST, mkubecek@suse.cz wrote:
>Introduce file net/ethtool/common.c for code shared by ioctl and netlink
>ethtool interface. Move name tables of features, RSS hash functions,
>tunables and PHY tunables into this file.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

