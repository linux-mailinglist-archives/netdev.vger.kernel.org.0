Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F8E639C1
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfGIRBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:01:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46415 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIRBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:01:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so8826978plz.13
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PU679FyfhXCaL2ezC5uP2VCWSsT2HL2Gravp5b8FT1o=;
        b=MTog4N+QkytO1ABiRZYX22BK0htrTtXji+ijrgwKE05Kw0cBkHiMht0hD+o7mrY2Ot
         xi8KZnsDe3rtS5ilrnjzXPVhH3YbtZIiYYnEQ2tcz2ENxkl2dfGdBNMSHvvDviwOnb5f
         Gs7uHYYkBERrkyfoLovLfR8FryJjOpHpdsE0g4Lao+gNsEAYUIVWS/pqgZU82izhRFmX
         ECRiv0lB3b8GtPO6irPKKqIgwnH+BZKwILwAJBDtJkSnQD5Ma+0TiFdfohfvd6+8Tlh/
         VyN6NudhZVDqbzjIuEzP+VoYjcnIKn1vRF0UDnzlbR2GJpHRj7RC468xbQNkO3Jj5056
         nvVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PU679FyfhXCaL2ezC5uP2VCWSsT2HL2Gravp5b8FT1o=;
        b=ec8muS6DJVnzCXeDB9hBh6jflRnPpRGHKBay64UAmfU+NmHmVVnvKikf1PYOAyQjik
         xcB3PBXjwK/Nlto/1bS1yRzQnq8VRTK09frdMX2QH+P5FXhDj3681D6Xg1Omtghu+MSd
         2PgQfDkr40xIfZGJw8WtRqT6/Y3BCjxLamLW1ofAZtIkHkJuzpbk+a8X3LJrR8H2REWl
         UQIYbhiaBX8JwQ7uUT4lZN0RpkpP/FXwlrIlUDQFwf5kRu5hAEBklIxZtTTcF3cOzvmG
         RC/ctsTbx01caiKDmPzreDdLngQpt8SmEBsC0kCCmoj/QOm84He9UZUHjzz+r0gplDtn
         /+Dw==
X-Gm-Message-State: APjAAAXbukQVfPFiWvV8uYrD9aYHd36cxUdCc1nat3pccwzwVnMKIQSM
        bDdICRVpgUoQ4HahRrf7t8YMvQ==
X-Google-Smtp-Source: APXvYqxrVwBWBB5uuJEPZzYSxkW5pV630SNOcb3gmuCkUiUhmgfBO9leMUwg9MM+DupxBu0njcE4yQ==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr34467496plb.55.1562691659535;
        Tue, 09 Jul 2019 10:00:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t96sm6490920pjb.1.2019.07.09.10.00.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 10:00:59 -0700 (PDT)
Date:   Tue, 9 Jul 2019 10:00:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        willemdebruijn.kernel@gmail.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH iproute2-next 2/3] tc: add mpls actions
Message-ID: <20190709100051.65bd159d@hermes.lan>
In-Reply-To: <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
References: <1562687972-23549-1-git-send-email-john.hurley@netronome.com>
        <1562687972-23549-3-git-send-email-john.hurley@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Jul 2019 16:59:31 +0100
John Hurley <john.hurley@netronome.com> wrote:

> 	if (!tb[TCA_MPLS_PARMS]) {
> +		print_string(PRINT_FP, NULL, "%s", "[NULL mpls parameters]");

This is an error message please just use fprintf(stderr instead
