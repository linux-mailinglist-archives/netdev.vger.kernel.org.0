Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C359894C33
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfHSR64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:58:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40169 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfHSR64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:58:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id e8so2865584qtp.7;
        Mon, 19 Aug 2019 10:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NDNJrzj9Dw812qWaq8KwN7iOuvYXUKWq+TvnNgSCkXs=;
        b=G1hJPsmS3mBTfhzn+i2blZeKrrs67Yzs30PvBA8yh+/ACcVPEKXU7Nlc+myysYX+V+
         Jx7P0ksoQOHex3WIGRSW9CdBDHYCKM0CsJlO48kOJtiGGRuAmljBf/4zcsM13YmiOy6J
         GRZs8UE3h/lN2fTtOTMCorJkhId3YLQP5/TzLNGGsWJfcGJ3vHt8R+QjxzhD8lExjnjs
         8bqZp+/xpRYs2TbbSmgSyqvKiaR7PvDgA2ehN93imkNeS6jWKhMqzbh+LY3yTlQtdTir
         CP6XdQ1iRKxh+mpxjfUIPPTzh85DSkMvYQdQk4vE7tcZb/nlnEdewCTW6Fb3e7WGzeaa
         X03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NDNJrzj9Dw812qWaq8KwN7iOuvYXUKWq+TvnNgSCkXs=;
        b=hv21H4RHCWBY+VR7pIL0CNxXeZvCoyy1d7qpJrNA3vLJHVnT6BGrXTwjicL8Gv8Dsk
         8uQ90blNFaEIppODtpOaTfYWaO6baIeiS9qyDnO76csgiQp8jvcNc9OS6/Ng/VgLz3gC
         rW99v98i60PF+2hYvctko4D4r/xRFqw+7nSu5MsC8v6fVzrf3olECpUOpHlUbV4Z2iIG
         dCddQDV/SASu6YHH7cBBr3uT10USRir8dUGlM5erzlQWV3NK2qq7e2zwj5Sz2+fUK68u
         CE3YD2b6p5XcUDWRSRUnTeD0bbn2ToKWdu/uoDD9Z/abgskHk1sXW3S/AIBkJVo/LPyv
         Mc5w==
X-Gm-Message-State: APjAAAXduBTMTtzqKyBiVeyQa/0gD5eEWrJj3dt8ax1GEV0iCrfRnIdO
        w4X2N7gcrAYGOWnZK/7Os+A=
X-Google-Smtp-Source: APXvYqysrk/Z1ZFxM3voZVp/K6AyYrhF5y7D159QfVB2zclFYMl8LuPvfRFlWLxYDhI6B1XUJsViVw==
X-Received: by 2002:ac8:3258:: with SMTP id y24mr21902824qta.183.1566237535122;
        Mon, 19 Aug 2019 10:58:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:9612:ee2d:14b6:21a2:1362])
        by smtp.gmail.com with ESMTPSA id d22sm7194496qto.45.2019.08.19.10.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 10:58:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 04CB3C1D94; Mon, 19 Aug 2019 14:58:51 -0300 (-03)
Date:   Mon, 19 Aug 2019 14:58:51 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 0/8] sctp: support per endpoint auth and asconf
 flags
Message-ID: <20190819175851.GF2870@localhost.localdomain>
References: <cover.1566223325.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:02:42PM +0800, Xin Long wrote:
> This patchset mostly does 3 things:
> 
>   1. add per endpint asconf flag and use asconf flag properly
>      and add SCTP_ASCONF_SUPPORTED sockopt.
>   2. use auth flag properly and add SCTP_AUTH_SUPPORTED sockopt.
>   3. remove the 'global feature switch' to discard chunks.

What about net->sctp.addip_noauth, why wasn't it included as well?
I'm thinking that's because it's more of a compatibility knob and
that there isn't much value on having it more fine-grained than
per-netns. Just feels a bit odd to have the other two but not this
one, which is directly related, but yeah.

Otherwise, changes LGTM.
