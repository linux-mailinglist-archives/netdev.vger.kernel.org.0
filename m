Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C212F47DCB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfFQJDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:03:41 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35889 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbfFQJDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:03:41 -0400
Received: by mail-wr1-f45.google.com with SMTP id n4so944538wrs.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 02:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cu2kAm70vPRVHWDXhNhnVeenuqVpX8AzovKmbdBh/dw=;
        b=HnTnNgflYu3E8Veaw3AaBb/oQlVrMNJeeHSjG1XB39msc+QO1OgqwjKWTIsgQF9y8v
         8cvmMhbphDycmmXLV18ODI1p2OdLjhGMQockViwDGknIF0IEMeBz91YY9frS0ECphNYv
         EvvCjlDw0g2b7lF4PxInPIkt+f2RnL/47rybLdnLHtt5QWuYPkKxdSHISGuBXHGxBmAy
         uR9edRr20+zssrlJWAiuGjddWaOLCz4ctLsE4mfBU/lddJW0rEeQZHcOm3oznEUvuD05
         tsnBHKusnRIQbC3m3nikraB/44Kvwqcbm+A1bU90gsUtSZpp1crpCZ6yu5igG8toGwVi
         KUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cu2kAm70vPRVHWDXhNhnVeenuqVpX8AzovKmbdBh/dw=;
        b=DbniXLCOy9HPR5+rd5wAFMUuW4oAJJ63zf+XxYVKOXI64OIi+o4294Y+coTD/IiF+A
         VLNg3rmxePP5r8iQVcLZgxDwjXRGWiaMd1b64QQ5Xuh3kQvDzoDlPnZqOBoVZbs1RDuo
         rI+ykPMy+Pl/UYTFCjqkcD0kU6Vm1v6H+0MXwTGejlcqTcpH9eGuu9B840c3eHpApGDE
         8OvtGYp8D+G7VD3HdkWfrp38MwGCNi+CuNc9sYrZXzQpgSZ4yJK7B1clA1r6AndzVxjQ
         ZMVeBcduf2IZFKruafV9Lv03CtBTz6Y6aMujEWAjfJjVhaaYZ6zcw41e5JGDe86WF/KH
         RG2Q==
X-Gm-Message-State: APjAAAX8dy2NSvwrEKPqE/c3G3iCAKa9broqM4rMIrG7t4urbdMmhHfl
        KVSnQ/T9iGPYC+SOGU2+hnmYMgWDcl8=
X-Google-Smtp-Source: APXvYqx3N9L1Srzl5+4eq6GAsre9xH85bkmx2MXysn4nfNDO56J5T+p17g429XNNCkMXGhSLtWhYFA==
X-Received: by 2002:a5d:6190:: with SMTP id j16mr15708412wru.49.1560762219193;
        Mon, 17 Jun 2019 02:03:39 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id y12sm11007716wrr.3.2019.06.17.02.03.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 02:03:38 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:03:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2 net-next] team: add ethtool get_link_ksettings
Message-ID: <20190617090338.GA2280@nanopsycho>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
 <20190617013255.27324-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617013255.27324-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 17, 2019 at 03:32:55AM CEST, liuhangbin@gmail.com wrote:
>Like bond, add ethtool get_link_ksettings to show the total speed.
>
>v2: no update, just repost.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
