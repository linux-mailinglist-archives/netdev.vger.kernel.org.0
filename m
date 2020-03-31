Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8034D19A273
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 01:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgCaX15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 19:27:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45282 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731331AbgCaX15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 19:27:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id t17so20049100qtn.12
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NTtGtElf4KM6ruolVX5/V+A7L1i8rEuz42hU0f0A9qI=;
        b=hq8uGl8i1eCthGXF5Hsxz6BwY7Zq7snSNnmTWoO2pbQ40X2ti3lIQS3FhrZh4Why/g
         7c/qhShSlR5GFQ8IjP2IvRTcmkJ4Vnjj8RUquSSd5az7z63Xogewsea1wL9PcBazUYbE
         NLYO14069JIvgvyTrb/GGr9xv3GfWlRbDPTQuIPDaojNctiFn5iQf4acyAiiyjEfXVP4
         0jADpZ7b2KdNTOpymyNJyxwdCzxx8L+5q7EgjpxtwfhO7J8yy9QW/Tf3UXHOgqjhoozO
         2fGtUfId5Xmk5/Q82ffVE/tbL7TnYFbgU/myEWvZrMSDCxbFGzRCer1DgKweAy5of4WI
         Wbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NTtGtElf4KM6ruolVX5/V+A7L1i8rEuz42hU0f0A9qI=;
        b=CyneSl31riTrg9iY32tnHHGmAL0Ae2faqDiAw3eD9I8FQF16xX44VpSj3o8YYcdhMp
         /DJiTMOU3upXzMusayrWpB252ZyHm15LbcHddIDaRBufPUK6zn3nT5xbRjA2OK+8WrPA
         ljsOACmtfeHxWF9g+erg2x6lKh4t523iplEJqf4VzpVsjjuIoqqHnQtgUsR1df0LVotE
         77Ft2G4Eybamki2qzOXicJ8IWRJ0tPmUUu0W4cOUn9cLtJ+kFWuYQRB0dyxLt8aDZCsN
         iJYJtl1rxawy6ZwxX1ZS1CGjpfkIVHouC9DS3xurycgQFfB5hqmnHhjcLwq7cGH2DBOQ
         4YIg==
X-Gm-Message-State: ANhLgQ3A/mMSuBxfJ7+ZuPDHMAqMcyB2mm7PlgXU/GvHLNTDpek71zHW
        1Zz6TaQC7W5u1FkQNkat7l4=
X-Google-Smtp-Source: ADFU+vtbkHEynbDuDUw0k3RWsNkHqP52KTSGNGrhhNqfNxzK6sl9L446OYwe1wkqmkUijGx9tUIhyA==
X-Received: by 2002:ac8:568b:: with SMTP id h11mr7650335qta.105.1585697276344;
        Tue, 31 Mar 2020 16:27:56 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:8cf:804:d878:6008? ([2601:282:803:7700:8cf:804:d878:6008])
        by smtp.googlemail.com with ESMTPSA id c19sm326292qkk.81.2020.03.31.16.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 16:27:55 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/3] Add devlink-trap policers support
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20200331084253.2377588-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7d011e0e-14b8-fe7f-7ac5-16cc6e4fc6b0@gmail.com>
Date:   Tue, 31 Mar 2020 17:27:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331084253.2377588-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 2:42 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set adds devlink-trap policers support in iproute2.
> 
> Patch #1 adds devlink trap policer set and show commands.
> 
> Patch #2 adds ability to bind a policer to a trap group.
> 
> Patch #3 adds bash completion for new commands.
> 
> See individual commit messages for example usage and output.
> 
> v2:
> * Add patch #3
> 
> Ido Schimmel (3):
>   devlink: Add devlink trap policer set and show commands
>   devlink: Add ability to bind policer to trap group
>   bash-completion: devlink: Extend bash-completion for new commands
> 
>  bash-completion/devlink    | 131 +++++++++++++++++++++++++-
>  devlink/devlink.c          | 185 ++++++++++++++++++++++++++++++++++++-
>  man/man8/devlink-monitor.8 |   2 +-
>  man/man8/devlink-trap.8    |  52 +++++++++++
>  4 files changed, 365 insertions(+), 5 deletions(-)
> 

applied to iproute2-next. Thanks
