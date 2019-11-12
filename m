Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2945F9A0D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfKLTzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:55:09 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41451 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfKLTzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:55:08 -0500
Received: by mail-io1-f65.google.com with SMTP id r144so20113486iod.8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 11:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CylV7vEgYMGXG47AibjGq725RdeZznGBZxWFkjLjRAw=;
        b=t2nCJF/J/0SMp3HN6cdI/bLZQYqQH6kQc2u26AG3fxHmLjsgNlB2ipLHatVxmU2Kdo
         t/sY8XS/O/dujXk7K3lQm9AHjEItLEdrVGG0/jMaJIiR9/YMA6qCFYIpXheCIc7JTbUC
         ZW+CL+VZ9j7kcjMXlMZynt6X1cRE4/4ajMS7G3nDp+CPNM+OMk3DqfZ2/7c+DHfESoQH
         TxSOSJV0z9a+Ru+1IjcWgtxMfFpfpBM4iJLWjQptafARmL2hlSUyVPlz27VGGa4fo0j9
         yK3vt3DMpa7HVxRFAHNQgJq50ixrVqh9GGwOTEYv9px6tBAZuyPVcceGP5zwpmf94rZs
         hZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CylV7vEgYMGXG47AibjGq725RdeZznGBZxWFkjLjRAw=;
        b=aqTv18x+5zqAmCQJNBySs3W3Vh9pzh867ZK/3bmWKRYJZtWRQZ64hLrganDpFOcVlW
         c+Mayi74K6pk7lvIpdd4btfC9kJp9SUxTGEbS7e0D5aB9HlwnIHQLEd4qxZCW0cqByfH
         EMo42gab+m58GjUfQ62+dZcOnBW4FUFYJSff0Asg6dr+H+GlCFR8WF19KLHaXiWd1OYT
         nRX5fEQM7QmV0Pxkii/lkJ7FVdkXQTucHwh9rDYuh+uqnPrw1TFPlQ9ZYesBKNqyijo2
         75KuNQRb4VjuVj3+bOLPjWOczP34tz+YAj9Xn6K9+CEOOTDzTuU4MiXUKeu0LPiGNGTi
         UBNQ==
X-Gm-Message-State: APjAAAWaX3nXj7R7rrj3GwRrBFbdybUZ67qiTKbby6x3HaHZklhk5baC
        AAZdx8ssHsVy8uCmCB7hRWs=
X-Google-Smtp-Source: APXvYqzlXc2lV/BYCVIHywGFHBNVi63TzhYR+AqrGJ//qfcT33CbuMiT/sbcyOGxZDByRWWPYiIEPw==
X-Received: by 2002:a02:782a:: with SMTP id p42mr7526032jac.104.1573588506487;
        Tue, 12 Nov 2019 11:55:06 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:5dee:f33b:95af:feb2])
        by smtp.googlemail.com with ESMTPSA id s11sm2674145ilh.54.2019.11.12.11.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 11:55:05 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/8] flower match support for masked ports
To:     Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
References: <20191112145154.145289-1-roid@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2dca1929-15a6-d7ff-c8b1-c2605bed6b2c@gmail.com>
Date:   Tue, 12 Nov 2019 12:55:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191112145154.145289-1-roid@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/19 7:51 AM, Roi Dayan wrote:
> Hi,
> 
> This series is for adding support for flower match on masked
> src/dst ports.
> 
> First commits are preparations and fixing tos and ttl output.
> Last 3 commits add support for masked src/dst port.

Seems like the bug fixes patches should go to master.

Send those separately, once committed I can merge master to next and
then you can re-send the remaining patches.
