Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029C611F0EF
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 09:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfLNI1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 03:27:37 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:43538 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLNI1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 03:27:37 -0500
Received: by mail-wr1-f47.google.com with SMTP id d16so1226277wre.10
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 00:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LHa3dQiWJlDXub8DbxjNfhIyEVmXkpSuaLzv1x3MU8Q=;
        b=yCegVpCUJgM3yIJQ0Xm4MHNE0y1Gqg0hlkBqf9b/k+ReB9iJxJpd7LFovejjD6agfS
         7o8hZMpjRfd3IbMTuhsvwbgwgANNfkEboTrAH9qUFTloUuNY1o0/Q9Ps3k5ncYhOPOhV
         s1x2NE56hN797W+K/QTFIzTpqNT5+jdB11SQJBkCoxuWp7xO45TNWa1rHrmZW9L8z1Wh
         /lJOa5OWjKLS+BoB0i4iR0NpH/8oHk+ZIVGmcCueAZh+8fuLqLoYfa2zVzmcq3MQ739R
         OjLjNPEKADCvUNm0Vtgz8oigCYAucSWmB0S4g3WkcvDay0Y9RQJjGnfhRDE/FXVTGC5+
         4x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LHa3dQiWJlDXub8DbxjNfhIyEVmXkpSuaLzv1x3MU8Q=;
        b=YmwK8u/Oq9fTaCqpo4gNw8qoJICAtp4HU2pYeTWIR7eIPJ1RbPbNRYRQSNf3fs61vo
         4k7tirG2UoTgUu9HzT1n+CyrdvKLIGRDe1B7cCloNxmc/3aWM3DxFvUfLo5E3ziEoqTa
         ZBRar9OhEaYdSHDy3Y2gUKy76h8v+mub6gkRhDuY0juYsZE/PZNoyBA+6k+Ia5/CCU1u
         AEE887NnreVa3wskXYm6ZmH5JZxKuGl8xWLFkBAKIx62042y0kAHBKMBa17xWkUQubtP
         O7dm0idT+C1j/ySC8u30yX1MyYVSDoLF7i0QG+MHqkRHmhOrBNS7geV4R/wpVX7MxTQ/
         d4yw==
X-Gm-Message-State: APjAAAW5m70oFwgYkES87Zwy6iXXT7aKMC4nAbCFqlDN7QDtRE0iFo2w
        601MEG9nn5ZS/FtebbxDE/y1mQ==
X-Google-Smtp-Source: APXvYqwlzhArMNrZkqvROQofomigQB+B38RPfp8d/+ns1go+Z4vvzrQIHN+N+4wuN64QcuM6IXp28A==
X-Received: by 2002:adf:db84:: with SMTP id u4mr18005133wri.317.1576312055469;
        Sat, 14 Dec 2019 00:27:35 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id i10sm12613233wru.16.2019.12.14.00.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 00:27:35 -0800 (PST)
Date:   Sat, 14 Dec 2019 09:27:34 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 4/5] netfilter: nft_tunnel: also dump
 OPTS_ERSPAN/VXLAN
Message-ID: <20191214082734.GD5926@netronome.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:08PM +0800, Xin Long wrote:
> This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
> KEY_OPTS, and it would be helpful when parsing in userpace. Also,
> this is needed for supporting multiple geneve opts in the future
> patches.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

