Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6785963D10
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfGIVFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:05:13 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43640 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:05:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so48204pgv.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 14:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YvhaZBKyVJdzIOl+gI4AZZAB8jMyih8v2/FTwjn0R9Y=;
        b=B/jmkUN1v3YEGeDoedBhpQN1CRcPA85m8EH7diW6J+IBC3tomzupOBUDhlx58Is8Qp
         SwcbraQm3yimD/R9nNoaEkhFN+c0ZOd1xNf/0JeBXin+AAIAEc3N4MXH0qchtIakRqLh
         CnlLQe5l5u0KK5805w6WlWwHY7nQWhukoQPGBek/mluUvwOZoFA13dc5oi0SXzdsJqC6
         Iwg6Ma9f6iUaduGkEQvjhZrJgF2nVxGnwNlqLy3aC6JBs9iGQhYgQQ4ZJvBYlmmhbgHJ
         fftpI7FQXe6N4e8djBJRPN2zev25R3Re9pCLUFFEPxkHUZFSTmB/e9sTI63S67fAJ+9z
         jpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YvhaZBKyVJdzIOl+gI4AZZAB8jMyih8v2/FTwjn0R9Y=;
        b=dEVFTpGa/4HzmeByJGhMmcd68dgIsmhj4lJiqbueD36ULYXxWVtaLqBEqvi0BsUqwX
         StLsDVBW73DMsnWF35ELcAHprhE0a3Ha541C9Aar1+J+1RSIVN02S+ifgklTu63dl2PA
         jIqXO+d131ilgQpodj4rEgZrnH8BhZCtT3Fwahch2zceZJIOSnuFiw2FBq38Kf9YAgs4
         qGGeTPZ5NKvdW+ax0UoGn8DO8UR0nDDcZczbMAfvVm9soCyUZOhE3RhsNOFFdM/D+xXM
         fB7SbQf5uTCm+FBf0KuZEwINKwDWHls0m52QibtjUQFXhIQoE754SM/uhqHfhOF1bu8u
         zwcA==
X-Gm-Message-State: APjAAAUoZwt5/GHQ+BKJTWoLUj9fI2tPD1G1hpa/0xeGoUNh8Jpyh9ye
        ijA/RWCG5CiMf/KW+yCV38Y3ig==
X-Google-Smtp-Source: APXvYqy/2ispeNawExMIY9rpJ5OlRoUV5mzt+sdv1bkoaHjokC53tHgBjqEKSqGOkoL54/4wUZuyiw==
X-Received: by 2002:a17:90a:5887:: with SMTP id j7mr2296509pji.136.1562706312840;
        Tue, 09 Jul 2019 14:05:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u69sm3948pgu.77.2019.07.09.14.05.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 14:05:12 -0700 (PDT)
Date:   Tue, 9 Jul 2019 14:05:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     John Hurley <john.hurley@netronome.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        willemdebruijn.kernel@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next 2/3] tc: add mpls actions
Message-ID: <20190709140505.75efc84b@hermes.lan>
In-Reply-To: <f202a7ef-909b-1c0c-2a75-10d989b4923f@gmail.com>
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
        <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
        <20190709100051.65bd159d@hermes.lan>
        <f202a7ef-909b-1c0c-2a75-10d989b4923f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 14:36:34 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/9/19 11:00 AM, Stephen Hemminger wrote:
> > On Tue,  9 Jul 2019 16:59:31 +0100
> > John Hurley <john.hurley@netronome.com> wrote:
> >   
> >> 	if (!tb[TCA_MPLS_PARMS]) {
> >> +		print_string(PRINT_FP, NULL, "%s", "[NULL mpls parameters]");  
> > 
> > This is an error message please just use fprintf(stderr instead
> >   
> 
> skbedit, nat as 2 examples (and the only 2 I checked) do the print_string.

Thanks I will fix those.
