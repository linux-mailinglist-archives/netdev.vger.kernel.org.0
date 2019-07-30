Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3586C7B5D0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388322AbfG3WlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:41:02 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:45915 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388315AbfG3WlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:41:01 -0400
Received: by mail-qt1-f175.google.com with SMTP id x22so59705400qtp.12
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1ASLyQGbkwp0TQVl4pU8cFkICWVNg8Itvv80D+XXkfA=;
        b=GJ5qDLqytrT9bu8eq1dScKi+gMVkE+jABuSmU5EUBwHO0VNNE5L/SqaVXIGOMLNeSl
         bOsyntqnXk4cUySaQQuUW+HyAFOBsRn5Qj38lklpOCzlMwSJGNtOcezvMGq/j+BGykit
         KwZ4waIUTsgcFREii8zAZ14quElhwcucdlfOC1lN4HOGs6ZgevNAHxjWdouTd9GSeuWR
         h0PG94rda6D/sKq9j+/1Q7CfRAG72NnJzm1HrrZTkrsu0d/BW3sBE6cCt4eCCDZkoeg2
         bmQxCaNgOAn7NSgRbFQAgJwyq5vjpkGNkuMUVLP5Gm4GIzMLFwiSNM6SC5OSyP1gt84c
         FmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1ASLyQGbkwp0TQVl4pU8cFkICWVNg8Itvv80D+XXkfA=;
        b=QNln7odUhGdU/BAaMPtXrzOgOWdMWcNAfF1QySah9IlC4WMgjmG2AcZy84lk1rVd/x
         Lf9omymMeRC6dhRneIWgAqzmZYF57AtnAII5CuwOXXfG3Ed75/4IVormduQ4nCWpL8u5
         Ra6rAenYPjJxJ9VcpnqpV2PaybRQP2DgfwIbr74fXOHNgRIh1bGWCoOlZpLQ3ToTWIbr
         OuUgxgleh9Ob2oPW+C/+wOXpzgKx3cnVRj0pjtxr4sykh64kWGOErYJmS5F4BuNNGsa5
         g3n6VWQ3an0iXE4S3lqdEesHLweUQ5YD7SxMg8l1Zukz1o9y+NjSiM/WZSqNT5EgPviT
         1WXA==
X-Gm-Message-State: APjAAAUcdx+QxHg9F0oX5tB04Tw08f2+RntL+i+25O+AXj/OHndnogKq
        5R9e5yaHz5qNHsoP0fVDd00XrzsUuHI=
X-Google-Smtp-Source: APXvYqxGaoZtUoyFOgdYNez0+DcAewOWI/76LkKFH/LgyLvGIOASO0VBqUc5egQQGUzFy4qiGaeh4Q==
X-Received: by 2002:ac8:3a63:: with SMTP id w90mr46975735qte.371.1564526460430;
        Tue, 30 Jul 2019 15:41:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d25sm26459763qko.96.2019.07.30.15.40.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 15:41:00 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:40:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 3/3] netdevsim: create devlink and netdev
 instances in namespace
Message-ID: <20190730154048.7476b8ff@cakuba.netronome.com>
In-Reply-To: <20190730085734.31504-4-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
        <20190730085734.31504-4-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 10:57:34 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> When user does create new netdevsim instance using sysfs bus file,
> create the devlink instance and related netdev instance in the namespace
> of the caller.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

> v1->v2:
> - remove net_namespace.h include and forward decralared net struct
> - add comment to initial_net pointer

Thanks!
