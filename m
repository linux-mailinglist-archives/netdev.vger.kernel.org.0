Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A22509EC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfFXLjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:39:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40126 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfFXLjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:39:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so13009618wmj.5
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 04:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ipWK5tH0DNRl0Pts3mVfPN5RNUtzRm2P2QltVX9GLv8=;
        b=kRMBhXCJWM7c6z/6XbKues+N451Dqb8jFGEHFmQ2tn6IMhj52Opri+9QmdmEb5j6/i
         B2KW+RSZfTNFEkBq5yC27ea6dbVsh8YIgi51CE9ZZpjzAg3xzi+YMXAi9VfAz1y6ItK/
         Ky3p836sUKbQ+YzoV2+5XY/O7nhWCNz7cnaYo9II/sM1KhyVUx/sDqQ/HDasCWhpZdm7
         iVicfqGqyD94Fuv+DUWTugLnAcEpiA591dIDl/wlzf33/yfAd7J93pnOa2i+qT0ebkKq
         D4in0qfm+W0jiuKPEqhDs7VCpLj8XweFqO0hGl5jYwTEQNNE7JyZVpQzODZboc03EJfj
         jqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ipWK5tH0DNRl0Pts3mVfPN5RNUtzRm2P2QltVX9GLv8=;
        b=GdyPmTs19vqJtQH/BCGI7oUh7qtc77DCODpuiVVGG3gcoHvlO7cKwgveVethlQgA1R
         YEcvQxq3l/U/6fxo7Sgt9C2uOLlQfN/3WmsW6dkisRkhiIBMpXuGvBZyYxk4S13ejFjK
         z+O4I0EqJzlAeEzv8foQnJ9RWKCCoCpNvW14zUW0td6Fg4gWjv4w3sNC6zTFrHQvTE9o
         Xmo57wdY+5TOsrL/v/28WZfTb4V4rMlueIScVd9PkSYrk8udD+B1CD3VoUymiktpN5H2
         KXfG/fEvyZn0E9kn93BCOAKyVE0xq5XZ9RvZeReTwLuEaCsdSNN7AKLKKy//V45PhWJD
         PSzA==
X-Gm-Message-State: APjAAAXX23hnLjI5RIz6bNU0TwFEsS5hgWOnmhNSHzML1sXxKtbgihxq
        qF0hCCw0cRSryPG4kjGzPmqIEg==
X-Google-Smtp-Source: APXvYqy/igWZFG5fQ3sjyHzQUi01zSnPoXms26BQez4ruTiQzewV6QpNXlJqKpWWuifb4/t5FuQv3g==
X-Received: by 2002:a1c:bbc1:: with SMTP id l184mr15392234wmf.111.1561376371814;
        Mon, 24 Jun 2019 04:39:31 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id y2sm9222688wrl.4.2019.06.24.04.39.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 04:39:31 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:39:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 1/3] mlxsw: core: Extend thermal core with
 per inter-connect device thermal zones
Message-ID: <20190624113930.GA5167@nanopsycho>
References: <20190624103203.22090-1-idosch@idosch.org>
 <20190624103203.22090-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624103203.22090-2-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 24, 2019 at 12:32:01PM CEST, idosch@idosch.org wrote:
>From: Vadim Pasternak <vadimp@mellanox.com>
>
>Add a dedicated thermal zone for each inter-connect device. The
>current temperature is obtained from inter-connect temperature sensor
>and the default trip points are set to the same values as default ASIC
>trip points. These settings could be changed from the user space.
>A cooling device (fan) is bound to all inter-connect devices.
>
>Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
