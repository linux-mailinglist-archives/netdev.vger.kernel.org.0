Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E28A4099
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfH3WeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:34:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37783 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfH3WeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:34:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id d1so4217814pgp.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 15:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ZsginlnnJhf/ghnQFYdPLSFaIzIeClyyZ1YbmzmWkv4=;
        b=seHT+u92sECtUeNMvwpbA6qDK2hqKHmB1U20DHihd8pY0qITe6jjjK8MEMzlb8hwOn
         BKkPzJb9LNhri+h/RvFUDOhNLb0lojBdAYmwx+hI2jMr2UIHERRuhalBAvp9ixfuM/PS
         fIPnL7LnBRfHpYmI36N8hGsm8Hy2xoaNNxJ5hySbLvjr5EKrP5b6UMCHN1iHi9IYu13U
         iWoh+afSKmWxN4RjBtuwVLUL1Jwo3j8tO5/Rstd7+vr845qlydLDEWPdHPeZDMmvX/zm
         Wu4JRHE8MUITK0a2h5fQyb/gMhqktFldb1VgQXSlEodE9x6P2DTTEhDc2rdSJOOalyH1
         V9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZsginlnnJhf/ghnQFYdPLSFaIzIeClyyZ1YbmzmWkv4=;
        b=r85Kgy3u5lySjpt/u54GCi2GdIkevEWqeQ0roYD1AkwUkgRYUD73AVNSE/WOeykqRr
         cUe0tiECoNwM3s4qIA2YI7+ZF5gcckrXdRDIi34HEHk+N9FzSXqe0MOLxbTLI+6+vFTf
         7XxWEtamZIDPaajuI69c3MZfRdqbmEHhDo2iz1pZr+gKQhF/MjdZvYi0krkOnV2A6o9N
         I5sWsJh5ljhyXL1QMZHQEyBPzE+QJVAINnrpJajg5nrIAG5Yk3Eldga/trA0x8Fhzjux
         pe/R5SOfIiGN+DIELP/y7nArdMgQ9KnB4SCuh1VlaR5hH6utFP4K5oO28NvlfokyOn5l
         4Txg==
X-Gm-Message-State: APjAAAU8SNuVIeIhzpLWls+ot3BWlFDanZSfabSdD+Kub9yEvzrcHxtF
        s43qcdj+w6wIMu+UaQQLJlz3Timdx9w=
X-Google-Smtp-Source: APXvYqwPM1YSz1UiGDfr9R5nq8w5G3kER9TIxRek1v1q+65rYpEqBV0eCbzLHnBqODMf7yoqHkIFHQ==
X-Received: by 2002:a63:550e:: with SMTP id j14mr13238983pgb.302.1567204454786;
        Fri, 30 Aug 2019 15:34:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h9sm5400804pgh.51.2019.08.30.15.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 15:34:14 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:33:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@resnulli.us
Subject: Re: [PATCH 0/4 net-next] flow_offload: update mangle action
 representation
Message-ID: <20190830153351.5d5330fa@cakuba.netronome.com>
In-Reply-To: <20190830090710.g7q2chf3qulfs5e4@salvia>
References: <20190830005336.23604-1-pablo@netfilter.org>
        <20190829185448.0b502af8@cakuba.netronome.com>
        <20190830090710.g7q2chf3qulfs5e4@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 11:07:10 +0200, Pablo Neira Ayuso wrote:
> > > * The front-end coalesces consecutive pedit actions into one single
> > >   word, so drivers can mangle IPv6 and ethernet address fields in one
> > >   single go.  
> > 
> > You still only coalesce up to 16 bytes, no?  
> 
> You only have to rise FLOW_ACTION_MANGLE_MAXLEN coming in this patch
> if you need more. I don't know of any packet field larger than 16
> bytes. If there is a use-case for this, it should be easy to rise that
> definition.

Please see the definitions of:

struct nfp_fl_set_eth
struct nfp_fl_set_ip4_addrs
struct nfp_fl_set_ip4_ttl_tos
struct nfp_fl_set_ipv6_tc_hl_fl
struct nfp_fl_set_ipv6_addr
struct nfp_fl_set_tport

These are the programming primitives for header rewrites in the NFP.
Since each of those contains more than just one field, we'll have to
keep all the field coalescing logic in the driver, even if you coalesce
while fields (i.e. IPv6 addresses).

Perhaps it's not a serious blocker for the series, but it'd be nice if
rewrite action grouping was handled in the core. Since you're already
poking at that code..
