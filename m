Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A7FDCAF9
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437341AbfJRQZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:25:55 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:34677 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394844AbfJRQZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:25:55 -0400
Received: by mail-pf1-f176.google.com with SMTP id b128so4219970pfa.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uh8k7T5KrJHpb+AxCg5qlEBOLfHO2e//8EVW3PbgD14=;
        b=dV9i9HT0bHmGEA5MkKJ68YiCpsKREeuHRScRWaC6Th1O58v5Lv4e/NPOqfD+lLdzec
         L0had2hw9j7gt7jaPDjAdWD/JqfCwFJlxBX6QJ7j9jq/9ehGYiCEK4NZV6Tf2nyvZ+qe
         KXlFAxW4z88/bd9WsmccoHAlgoN6iA9rVNj/1Si1b/pIdXS76iwUmC67g9mjNKDsk1vw
         EAYHaxAqAPi9mzGusY6aPHfuBjgrDih2rrG5DhdopAbgu2kreLJ56aFd1knjGPMtIJbY
         qBS9czI/Uxvk7Vj99fJLYCkhwncAXEtEXTZaZob8zc8iRhgahPWWXvDgNlNuJuXIt/un
         igRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uh8k7T5KrJHpb+AxCg5qlEBOLfHO2e//8EVW3PbgD14=;
        b=m9Y37tY3TGBmUML/LzKkEgzEe6AaiQYuaQH20tDjvrkJyMdPJ9cg46424C0L+Eje/s
         GqRytvTyfB7V5RHTVu7eHAe22C2Bvf2Rtnk4BT1x3LjmvjHcBcHrFE3ffaQpO4u2rsUj
         qNZEt+fjRiE4kLRLe0xw+jYVuu1SMbWpXBhfPr04q4AXlIOSA7Hzop1S0Am9n+aGGtSG
         0ByGkmlmIVhDWw7zANK7a9gVq6ZkMs0i9HQcO0fLLRzchagqwFmxr6ovLhbxMtJ4aXiP
         SqYv01boPWLuj8Qve6sASyvSZo16id273zJENTmEnTPqBEvHBVp3W1ybtYGRt86fL+Xf
         V9wQ==
X-Gm-Message-State: APjAAAUcb1SfpW4//X4GmcTfFcdEY1sEyGyOuJt69Zb0qDyzT/pumkJs
        4uBpB/0isznH/LEVrYsM0dxrow==
X-Google-Smtp-Source: APXvYqwzsvcM6QGly1cL1yQF+11PJ2/cQ6kuo6gRBG5BNAX183BrPPaRI+d+6oxjGrBlZQefnUk7OQ==
X-Received: by 2002:a17:90a:a407:: with SMTP id y7mr12130184pjp.124.1571415954154;
        Fri, 18 Oct 2019 09:25:54 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d2sm5965699pgq.74.2019.10.18.09.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:25:54 -0700 (PDT)
Date:   Fri, 18 Oct 2019 09:25:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018092550.6d599f0d@cakuba.netronome.com>
In-Reply-To: <20191018160726.18901-1-jiri@resnulli.us>
References: <20191018160726.18901-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 18:07:26 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, the name format is not required by the code, however it is
> required during patch review. All params added until now are in-lined
> with the following format:
> 1) lowercase characters, digits and underscored are allowed
> 2) underscore is neither at the beginning nor at the end and
>    there is no more than one in a row.
> 
> Add checker to the code to require this format from drivers and warn if
> they don't follow.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Looks good, I could nit pick that length of 0 could also be disallowed
since we're checking validity, but why would I :)

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
