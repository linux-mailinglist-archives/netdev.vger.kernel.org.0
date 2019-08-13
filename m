Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53E28BFD6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfHMRpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:45:38 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:37862 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfHMRpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:45:38 -0400
Received: by mail-qt1-f169.google.com with SMTP id y26so107230267qto.4
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rqCMayhy7xKIxQ/Udl8NaVoZEqcFVaiPOXywwzivV6Q=;
        b=Y5mti63v/FdirCS8JLS6vmkqfAAdU67nlyKJvozMCrnKvypxTwYsTQZYxDmDVdPcnA
         E0//1LQFe/1BygdbzLTCZV/oYzORF0ThysaxyTo7W1S3Wpk9zDSkfEqg5gngc8WJoBn4
         GBGW3opKugMvpD6U3pcLTYHxL4Rx5wGpBQNaXHqT9HXJpzSKzr/DQQDbIs3z/dO/pCAW
         /X8967PTbPsYUX+XAVCsRxFfjghJl3DGCmQ9wt4Bz1WZyerDuFGM3TtHBat+4EStNMyN
         /cURGpXZ1B2potVh0BaPR5AgRE7HIPtX0AIwAchE8tLkuh1vvu2BSIrNMAwSX29gzT37
         HRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rqCMayhy7xKIxQ/Udl8NaVoZEqcFVaiPOXywwzivV6Q=;
        b=NEtqaSKGdWOk5HdVKUojxy+lln9LLXowEmvoQcqJMPGGVTwccbBN8ClYtXIHFntFjE
         JEAjX/MflMue0OnAuwcy+WD1ZQBsN78AQmPpCK71yqOCvh5nv+S1HdYeTT4ePYI8EMQh
         qvp4mKg+go7tkI8W8lR37qrp6kxTAWC8hnHTCpMnedDSQuxtMPkFFIhq4f+G7VistCjO
         s418NCt0iN/cUgy3xm9o2PZhP+/ONTP6pkWX5YRO2gsmOZ3g7r/ptGZcM8LGLu5PPnXu
         m4F8v87X9EYR7HIXrCM3JMmbuUvgieoMqfEQTaU8goxkdL9mrzK+0SCBwNejv/lrcY7W
         MF3A==
X-Gm-Message-State: APjAAAVqzzSW4PR88NncGlX0oAMZ+m3VAKS1UT+9C/sABxv/e2CVeOW2
        bFOAtOs9knhCGzmMpcqnea5BbTzfb0A=
X-Google-Smtp-Source: APXvYqwNJm71tsFvkQaT51QBINi6QaTnJmVnpiJxEHzzCWZOx3XRWz9cR9gzpd3m4Tz3xuTaNMeWzw==
X-Received: by 2002:ac8:60c5:: with SMTP id i5mr31255729qtm.352.1565718337731;
        Tue, 13 Aug 2019 10:45:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u16sm55586406qte.32.2019.08.13.10.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 10:45:37 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:45:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190813104526.481b90a4@cakuba.netronome.com>
In-Reply-To: <a9fa6f7f-7981-6077-106d-fa2abfc7397c@gmail.com>
References: <20190812134751.30838-1-jiri@resnulli.us>
        <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
        <20190812181100.1cfd8b9d@cakuba.netronome.com>
        <a9fa6f7f-7981-6077-106d-fa2abfc7397c@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 19:46:57 -0600, David Ahern wrote:
> On 8/12/19 7:11 PM, Jakub Kicinski wrote:
> > If the devlink instance just disappeared - that'd be a very very strange
> > thing. Only software objects disappear with the namespace. 
> > Netdevices without ->rtnl_link_ops go back to init_net.  
> 
> netdevsim still has rtnl_link_ops:
> 
> static struct rtnl_link_ops nsim_link_ops __read_mostly = {
>         .kind           = DRV_NAME,
>         .validate       = nsim_validate,
> };

The test harness is the only devlink instance which may 
conceivably have link ops. And implementing the behaviour 
you ask for would require core changes.

We are back to the precedent by test harness argument :(
