Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299454F0DF
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfFUWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:52:18 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42526 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFUWwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:52:18 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so2162480ior.9
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 15:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bh/l4RhxifNo1gZNnpyPeTv+6SazxA0eJNTUAwcJJ78=;
        b=mcePrsZ1iUtcsi4mCz8eouiIb8Go5ykWwcg1HAzDMhOEZzVO4ldZ0WZG6Ub+bYz1fa
         7yij+8PvsvsG7XtbiWqG1riEvKa5i+roiUhmp0ZeCdXpk2uvPLXmWbAznEpH76vU+uQM
         483JJiikc/rhNnjWvpO9hR13TwtnvAaXNzeKSajOjeZLbpcekzaAKE+pU5X2pKY41lfD
         PigmaQk6IqeqacOj2TbgEOYxMnoBIzIWp1R67j5YQCQa8zoemDjFGUvpVjZEN7BUEYyJ
         V6eKzI3lQ8/prejEJTSt3JQHTuKLvF0ctiMY2tT5JFgBTxeJOKJTCMqgezzUN4hbPvNz
         cg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bh/l4RhxifNo1gZNnpyPeTv+6SazxA0eJNTUAwcJJ78=;
        b=i9cz3JXXAROV1XLPQOO9S2ZYy191Y0s5IlKmzk7KnsIpI/4LB+9Gh2FBrPrkx7JqgH
         LOmFw50ShhTNfC8dUtmQrVzdBxViwta/GGispqTlza+/IzfH9sAoDvnwFudfs0EUZZ9l
         q5O06DblmVVs6PxD0KQ5zdX6Fnjhf0D8JYMQnqWKxwS0C/mHQNKJV2QI/7vE7E2LFePk
         SkxLb/6GA46QjzRsFHoVYCW/om5wLUxsCkNEZQr5NORIQaOACE3Gw4ucpS+JsPd2dk5W
         tV941ZBuJEfaTCWa1BZHD2T84/NbCwI3JabgYtD/T3bDowxOXC1SwZYAKLksZHXzqoJN
         UEqA==
X-Gm-Message-State: APjAAAWQNWLq/5XZD9pjUQXNXHHPRKL48RfKQ/Z0i9gYj1E5DStWz8Re
        ttkbrHvEro/t+50Qf7e0I4c=
X-Google-Smtp-Source: APXvYqyo1a/Ik2xGcP00d0Dm8MpetLiAwHTEHQ8g8GU8DX0HwC2tnJX6TGFSjjiPD4Jrbi/1JotkbA==
X-Received: by 2002:a02:69d7:: with SMTP id e206mr118846374jac.21.1561157537548;
        Fri, 21 Jun 2019 15:52:17 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id n17sm3689968iog.63.2019.06.21.15.52.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:52:16 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: q_netem: JSON-ify the output
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20190614172817.14817-1-jakub.kicinski@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cd06748a-5d75-13a6-ba6c-434fc600b53d@gmail.com>
Date:   Fri, 21 Jun 2019 16:52:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190614172817.14817-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 11:28 AM, Jakub Kicinski wrote:
> Add JSON output support to q_netem.
> 
> The normal output is untouched.
> 
> In JSON output always use seconds as the base of time units,
> and non-percentage numbers (0.01 instead of 1%). Try to always
> report the fields, even if they are zero.
> All this should make the output more machine-friendly.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> ---
>  tc/q_netem.c | 174 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 107 insertions(+), 67 deletions(-)
> 


applied to iproute2-next. Thanks
