Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA00B0E69
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfILL7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:59:48 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:52666 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731490AbfILL7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:59:45 -0400
Received: by mail-wm1-f46.google.com with SMTP id x2so1845916wmj.2
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SEaU7NG9QQ2XMkNrHm9HuW1AKhNCnbR87jUn+FgEND8=;
        b=tCsX42kiEGAunJjssZy9Jmdw3Sh/rIBnpRVsDrt3UF8nozuTWzsA1ftDPYOuTy1JCH
         a6VpXTGRh+rbmfU804nDxwVBWqIxQqoPiRTrQdd8XY/mUcefywpziNLgNs7dIRe9dp0a
         qkAUwFG4yVHJe0Pw8xTOisogTmbhnS/Q2CqrjI6KJ3lEQe0xlhXnCoE0YIAe1ewFp8gP
         4EYvo42DNlELibilQgtJqXzpIuxqtMoXfkR72DPc2UqE48tykK45gfV57wQjHl/hjcNP
         9iBiTqka/ZSVQ3n45Jm3uYFZD8Wzx8L58PWh+9e+qz5Wa+m6eZF/AK/PZYHI4mgizWoH
         ufHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SEaU7NG9QQ2XMkNrHm9HuW1AKhNCnbR87jUn+FgEND8=;
        b=c70xBJvH9AfZlvmXvU3RuBhBmMnxTlTvHcn2jUU6FFxgF9lXbel0sYFTums4o9q11F
         9eLuwG9i5R0GR8CAqP/Pjjgcr8xJ6vA/t9sHxXT5zfG8sOOqDrt7FC9PE6YcvH+znHiY
         HfgrXLYrhjW5L75gdPFyHv/V5Ew6+AHd3AydRr+6MelsZX9pr1hwEzUiFlqbF84iyemy
         9BT99D1cxlM6sy0Y01yzCZQruZUIgTqt5q0gYxLGEmjE1ECdVgKN0wz6pYJFj+7+6Ze+
         MyxEDfVNsDGz3SfxjKrqww7bsL1KKtXEJ62Y3kaGjh0iXvl4Mrvyxe6SIiFok492Zsmy
         /7iA==
X-Gm-Message-State: APjAAAXfuHxSpgP4sieFhb+rZ5kvlZQoEI7IpM8xLLXP6vF8Pars4Rmc
        Etv/Q/QmfItGkJTPfB4FA60q1Q==
X-Google-Smtp-Source: APXvYqzem8nHQZbQJKywnMayO7z7Db/ty1fJSno92eZA2sRFnWvHVjsLJjXkRhRQIR4fS+oZyqecUQ==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr8676920wmc.124.1568289584018;
        Thu, 12 Sep 2019 04:59:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n12sm4993623wmk.41.2019.09.12.04.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 04:59:43 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:59:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190912115942.GC7621@nanopsycho.orion>
References: <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
 <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
 <20190829052620.GK29594@unicorn.suse.cz>
 <CAJieiUgGY4amm_z1VGgBF-3WZceah+R5OVLEi=O2RS8RGpC9dg@mail.gmail.com>
 <20190830170342.GR2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830170342.GR2312@nanopsycho>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 07:03:42PM CEST, jiri@resnulli.us wrote:
>Fri, Aug 30, 2019 at 04:35:23PM CEST, roopa@cumulusnetworks.com wrote:

[...]

>>
>>so to summarize, i think we have discussed the following options to
>>update a netlink list attribute so far:
>>(a) encode an optional attribute/flag in the list attribute in
>>RTM_SETLINK to indicate if it is a add or del
>>(b) Use a flag in RTM_SETLINK and RTM_DELINK to indicate add/del
>>(close to bridge vlan add/del)
>
>Nope, bridge vlan add/del is done according to the cmd, not any flag.
>
>
>>(c) introduce a separate generic msg type to add/del to a list
>>attribute (IIUC this does need a separate msg type per subsystem or
>>netlink API)

Getting back to this, sorry.

Thinking about it for some time, a,b,c have all their issues. Why can't
we have another separate cmd as I originally proposed in this RFC? Does
anyone have any argument against it? Could you please describe?

Because otherwise, I don't feel comfortable going to any of a,b,c :(

Thanks!

