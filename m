Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 365798E245
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 03:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfHOBJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 21:09:14 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:34868 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfHOBJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 21:09:14 -0400
Received: by mail-qk1-f182.google.com with SMTP id r21so729150qke.2
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 18:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HKynoRmPX6ZL88F0cyoA30v0kWsjvw8QA4wbesxm00w=;
        b=YnsamKwNbeYwKsv5qsBgrttkE5UZGhGZxJSbs9VSycHnfsVWXevfAZng4VdX6Lc3iD
         p2eBKU0L1P1/Oe61li5su36/vwvDxuKEbSAgNBsDZXxLc1PCKT6NUdE7MAoVrFe68eQZ
         7BRh+XZpXujldThtJmZrergBZMh/nWXS6HTjmsJ7ztsSZbQo76iOA2vAKZwYW9msGj3r
         BGEYglMmY+GSGjLsO8+3v8FTkBELZOAFi+FOS0qP/4IVlvum+glDkVnqSyfz3PNJVh8+
         74LEnkucsg64Pu5bJ/yhpIxBU7u4IGfG220yxds19UQPrr9iDY51y7vd8u9YLJ+JWbGs
         VlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HKynoRmPX6ZL88F0cyoA30v0kWsjvw8QA4wbesxm00w=;
        b=O6cB95zLscpuMNYLUci5kIcQsRKhbA93M52OhCh+K9xWCQUvZGkj1nM+gtz4hfXUCs
         rZAO46BKlk8q9pLHOUPggB9e8iEloLrQiyL5g9psIuMNicm/Mt6fY+JxyAzSXDL5ZdE+
         XCxY/c9UpZU9NdmR5657MV25Kmndx2ntEW8eWBnOn1OsN+WG2aygRjGYcFqOu+UpN6cb
         nGlhvW2nsDEad7SJYbGsgOaiTo+mk6Jmsej3T4QmlvNdivqyuukv+OeaVtadTONqOSn2
         VRxDA2NAzCgjWIaFUKkL+HLKyD92bfMR1JiDdvq26+Mt/hFTqwpckurVf5YS6hvp7bva
         PtLg==
X-Gm-Message-State: APjAAAWoLabMbzUoZKbpxgi6tYWN8d4Y24bFdl4gMQyHOcGnlMQ9/X4s
        KCQuIgO0/nJboPvKzJr6ZI724Q==
X-Google-Smtp-Source: APXvYqxk9WbZ4gb21CetMFS9RfP0VJgNSNt9UGYEUzdYtQ1e3oaRQI5K6pVufHdK6U+HEB/xjG9b8A==
X-Received: by 2002:a37:4d4c:: with SMTP id a73mr1996721qkb.66.1565831353505;
        Wed, 14 Aug 2019 18:09:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a135sm713015qkg.72.2019.08.14.18.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 18:09:13 -0700 (PDT)
Date:   Wed, 14 Aug 2019 18:09:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/2] selftests: netdevsim: add devlink
 params tests
Message-ID: <20190814180900.71712d88@cakuba.netronome.com>
In-Reply-To: <20190814152604.6385-3-jiri@resnulli.us>
References: <20190814152604.6385-1-jiri@resnulli.us>
        <20190814152604.6385-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 17:26:04 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Test recently added netdevsim devlink param implementation.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> -using cmd_jq helper

Still failing here :(

# ./devlink.sh 
TEST: fw flash test                                                 [ OK ]
TEST: params test                                                   [FAIL]
	Failed to get test1 param value
TEST: regions test                                                  [ OK ]

# jq --version
jq-1.5-1-a5b5cbe
# echo '{ "a" : false }' | jq -e -r '.[]'
false
# echo $?
1

On another machine:

$ echo '{ "a" : false }' | jq -e -r '.[]'
false
$ echo $?
1

Did you mean to drop the -e ?
