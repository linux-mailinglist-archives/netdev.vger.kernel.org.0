Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88D5F7431
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKMk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:40:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41778 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbfKKMk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:40:26 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so14454346wrm.8
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Px/3IgKlZLjIl0WhRLUUvz89/T/Zq6xKGSUTdN+Yv0w=;
        b=V4zoPbeRk2DXxGDvA0hZZ/iRgurP599oz7XaDBUFNsPWaWP+Z7VzfHJvjcrdC2XIgK
         K9kRBnx5k7YBi18+6OpA5MKfxxU40MdYpwlyYai6Ejh3aenXSxyTKAd9asKVr5OYzFIG
         YMv099W8M2e+Wh/Z3RrHq9YYeNIscSi+omwRa9x8d3D9wuR1LssEJ1eJ5wDvJ7fD4iv9
         J5741vxdpuck+vLte24ZAc6Czr4Q3WfopzX+TJ81/DYUa139upQBUKacehwH+pTsq9sp
         6+X1rmxs7FHxafU4bG+DW+Npx9xirTnX7a067II80uukpU6I2G5Fh10Zwq5/O3ry0PTF
         zZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Px/3IgKlZLjIl0WhRLUUvz89/T/Zq6xKGSUTdN+Yv0w=;
        b=lCkj/pzRvG4YLOrOQr1gHNG7GnxElI0yT03trm5PhQuIBx89vV3YPk0R0fP6IzaaiO
         x8vbGgbhjvyGsVpBCMef2JmgE7c0YayXPgGQO5j2VIgJcf5KFkYvwavnoxwdBdgE/q5e
         ldJzTGwrAkV7Jgp9zQsMoRA/9qcCoc5r4yR10xxuwmI75ZXpREoo52IOcckbDP/etKmy
         UF3IexGnySLlYfN6Hbl5Zysc4OwNvKBwI1Spn4bJpPthDCOqM+FZnU/jeBEh3YufU5lw
         KJ2V0caz4dXgYJ0sAJmsU2db0qaHWZOAehZY3RAO61cVLlVDyjHvmxAbu2JsNHMOFx6m
         D1Mg==
X-Gm-Message-State: APjAAAV/cAOJJE9+kwl5nKFxjPgI3V8jWli/yN2uhFPI20/kNbYvgBSY
        a55qsiw0KP3mFUMtKYVVYsze/+UvVH8=
X-Google-Smtp-Source: APXvYqxSf1XXhVpz2hHdRSTexqZQpj9hKl2AKzm3AuHvXmR9e6d5LDRk+7V912Wu9YV/9n5Kf/xrmw==
X-Received: by 2002:adf:eb41:: with SMTP id u1mr20024783wrn.89.1573476024388;
        Mon, 11 Nov 2019 04:40:24 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id z8sm13857859wrp.49.2019.11.11.04.40.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 04:40:24 -0800 (PST)
Date:   Mon, 11 Nov 2019 13:40:23 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] lwtunnel: change to use nla_parse_nested on new
 options
Message-ID: <20191111124023.34m4k7lxyxfku7ww@netronome.com>
References: <78f1826a019e62b19a435a1498114274fb34223c.1573359382.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78f1826a019e62b19a435a1498114274fb34223c.1573359382.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 12:16:22PM +0800, Xin Long wrote:
> As the new options added in kernel, all should always use strict
> parsing from the beginning with nla_parse_nested(), instead of
> nla_parse_nested_deprecated().
> 
> Fixes: b0a21810bd5e ("lwtunnel: add options setting and dumping for erspan")
> Fixes: edf31cbb1502 ("lwtunnel: add options setting and dumping for vxlan")
> Fixes: 4ece47787077 ("lwtunnel: add options setting and dumping for geneve")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

