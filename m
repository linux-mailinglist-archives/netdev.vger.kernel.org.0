Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E9CE7719
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403932AbfJ1Q6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:58:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34613 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbfJ1Q6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:58:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so7290864pfa.1
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 09:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tF7tdLHfS0fP7oi8tfJNWAUfUltvOw0MwWqAJjn4kEQ=;
        b=LnePmIr4w25q30rrOr6fJZgL0ME6udGWOKwowqgs0tQTqpr/gQtlPa5s+PsTXLgptP
         EMB05PGyC4aENcLI56eaQrmHObkBpB5ZAe3iB90klP55OSd+TbfXgRsumOP/s6eKUf9v
         zInQASNY63oxSebc8Ue6wLzrOvIAxYeUjxFP8C9hnax+IHBAxnZ4JTZ09tsEBbJeIgI3
         4jWSj+5zw/FWGSZGShXHKgaLRa5jNOunGLKZS2Jtebpq6dz8kMMSREkvLEYg8TS+/SDv
         RH1T8vdkEP7Ob4lhXMlCt6K4WUXx9X3qn94IBh3n7pq0E2qU34hBc2TlYGtU0/6GYVhW
         aJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tF7tdLHfS0fP7oi8tfJNWAUfUltvOw0MwWqAJjn4kEQ=;
        b=TRX7ZjFUULWOzH8bXTHy030mry+Se3MXysCo9NeG4Q/+BtX3f9Ry63hQ/JIp9yzQwH
         Hu7kavotpCn2R7u0V4G28RHmbo/s1TGHJqcv8uTEyCNEQbJbk2pVAg3s1cS+HiHXZtk1
         ayLwKiEVoRa4XeFrM4TjqRgQG2pcWlS61SX5ILX0qZqWIqcg+O56FzG0rwVi8LFXyci6
         Legz3FX0wVDAa7piIN6H3aYLXY51al13NuYmv4JJlrfoWH8CMK5xqCsjWyfrZZJNSYuw
         wUgEpqDxMRDPsMh1j41SZWlcPnwGvxi4Nf2+xHULRc376yXY4ZqLChg5J0qh8snosyEh
         bdAw==
X-Gm-Message-State: APjAAAVCLLCaAvgXOzxN7NkJcKC/CApvobVS851Znf/KnJs65luo7V3k
        5IgA7cqnfMQxAD1AQ6DUDCbfKg==
X-Google-Smtp-Source: APXvYqxFQAbYVwztlH7eXZ7TXgcVy7A316/bBD0yRZawGFzbGLvPfXtsBkR/RaAmF0L90yZ4MiRSOQ==
X-Received: by 2002:a63:e444:: with SMTP id i4mr807390pgk.247.1572281891132;
        Mon, 28 Oct 2019 09:58:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e17sm10838157pgg.5.2019.10.28.09.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 09:58:10 -0700 (PDT)
Date:   Mon, 28 Oct 2019 09:58:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH iproute2-next 3/3] iplink: bond: print 3ad actor/partner
 oper states as strings
Message-ID: <20191028095802.5b5d5b43@hermes.lan>
In-Reply-To: <1572132594-2006-4-git-send-email-aroulin@cumulusnetworks.com>
References: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
        <1572132594-2006-4-git-send-email-aroulin@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Oct 2019 16:29:54 -0700
Andy Roulin <aroulin@cumulusnetworks.com> wrote:

> +	if (!is_json_context())
> +		fprintf(fp, " <");


You don't need conditional here.
Use:
	print_string(PRINT_FP, NULL, " <", NULL);
