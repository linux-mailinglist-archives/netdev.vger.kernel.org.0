Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA5D34F61
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfFDRzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:55:42 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:45331 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFDRzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:55:41 -0400
Received: by mail-qk1-f178.google.com with SMTP id s22so3404290qkj.12
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nJX+ak9kthoxV4MjGnmIKBFS9WdnLXiJdCvvXEETDls=;
        b=ZK/eEqQ61daYXSYDMSMNIna2kYYjFI2rsdZ60eStSwbEZ1UT3cWgrpU4vLRMqYQecU
         TQ+t+FtkGOfIMMuqI0jXys8GqhpTxAmKHmyTW8owmrxTt69H/gvG00nyo2PR5yyId2LB
         uV+wa/Lr7b38RyQRH4/EP5h8RXGrnnbHQcOrbAH4iCGRqPf2bBTCW2Xn31OcN15oNhT4
         sMxJ/T2iMJcr7iABgSe8CrBM7JEegDs11km8lQWNi1dSjHolGv1JwjnYWzci7Q9bBSqw
         7BZUU4irz45jyq0OgZ00W75NDwNjm6EODyYfDYILVlmOLUON/a7yT/BmjKg+kvP2Pfir
         TpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nJX+ak9kthoxV4MjGnmIKBFS9WdnLXiJdCvvXEETDls=;
        b=iksbjv6igS4xSVYU1bBdGyAUkq5CIBWN/Q8t4r3s2lTPZEWeG6+jB6g9HehsKR5MTq
         K/ypRn/BVUFosJP/oYEDY150Me06mhn+C5iusWT5D74hNcYzGIzdsjtzZGgmAujof1l/
         LXgEF6ndplOd9uWG1NTA9eY/RgoppaGuefi6Rrahaw0tbWfIF+eatZQkBwYOuZKdzGCt
         PnWL+BFwyOYw9rf7U6UpqUwEbOKlwUU5tWCXNO9nxE0IFJ+XHn37ayRYT2uFOcotXf0+
         qLpSpSF336JJBS5saE2mvuruffCWfLnWuW/sepJvWbyReLM1uaGU0kAVkF0GoUVyZPLO
         XZZw==
X-Gm-Message-State: APjAAAWPj545QcUBpBoktLicpeVelQe42kCj79MX7+CNhGCEkqBPgj0z
        7yq/bTCPQjEz/xJ53XTFsjPQnA==
X-Google-Smtp-Source: APXvYqzRetz6hsyemO9lHerSEpRPeGeyiD52b+qdOEMLZiyHj12r/akGzbPH17IneHT54OnK5PM3pg==
X-Received: by 2002:a05:620a:1425:: with SMTP id k5mr27913467qkj.146.1559670940867;
        Tue, 04 Jun 2019 10:55:40 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a7sm7921581qke.88.2019.06.04.10.55.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 10:55:40 -0700 (PDT)
Date:   Tue, 4 Jun 2019 10:55:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v3 8/8] selftests: add basic netdevsim devlink
 flash testing
Message-ID: <20190604105535.5642365f@cakuba.netronome.com>
In-Reply-To: <20190604134044.2613-9-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
        <20190604134044.2613-9-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jun 2019 15:40:44 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Utilizes the devlink flash code.
> 
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

All looks good too me now, thanks Jiri!
