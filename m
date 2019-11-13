Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A73AF9F36
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKMAVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 19:21:33 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:37801 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKMAVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 19:21:33 -0500
Received: by mail-qt1-f179.google.com with SMTP id g50so584353qtb.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 16:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qi0ysWBRqANE/Q3rJU+TBVsuBBeRG9pAudm1wBXhrzk=;
        b=c3j/L6gRmoTTgarBrZw7Jbl60CTbdQ0vvtPnXWjzPCijutnxzGmSglRosDvSvv8xww
         d+Ie0XRJTBopt4ZoffT1LuVpgDx+l5a20a7gYx6TloZItWdr3eyDi8oiTvC7bE3aYeM7
         Kli2kTH9JbYoKiiUL5H3SMgco53+p+JvpNDy4l0DX/4B5t/+p269N+r9NSKIOymBwGg1
         wjt8G60uE2+sL7kzJW6sJy+pQR8wh/2oD9iBM6V3l6giuH71wOSobYLZ3y7CcZKvcrwg
         yZWSvNjLUgccoh0UunyxllItsGFvCVLZKtXuACEh6gsN1fEgpKhrKiX7PCGnkaq0Aisa
         qRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qi0ysWBRqANE/Q3rJU+TBVsuBBeRG9pAudm1wBXhrzk=;
        b=qwvrwaPU1j8hT4fk4LEt7SMKnOzyzx/ZncWPVRxtmbmtO+MvZdsWzhEb3sR2Jqpj5Z
         npbE6bubtvACRqtGwdwxYXE27lhIqjtlXI31lfenxomPZuj3CJ/7k6ZD3SdkM7SppMJF
         vKYEv59CS5K0MqB22yeN6jjhIa+4rcPJwMgS9LsCnW2ZK21jA+ezKxwui6hjQlPK3vg7
         O9lHDdcwXfPJ9NtGlG1WliRTdiNKd1NUE9aGDOnSDrqg0mjhI4h98tmV2+ZjlfPdYEYv
         RlIP2PiGWr4JZItrX8iv9/30RwXiOVltQSQ9avQ8jAUk9AWv0U+ksdcSJFRGHbdrHoUd
         OqvQ==
X-Gm-Message-State: APjAAAUXwGxm6va1uFzr9tawVfv5/eAWDj/LPyMxGYHCZFE2RjKDorQ7
        JvV4A/qqv3o8fOC/kLlmZM0=
X-Google-Smtp-Source: APXvYqyDgROYAj+837M5pgEfSTnLXoO+kKYTo3WzuVPHQlrfp9UBlaabdolXQTk2kjdHdz/rDSXljw==
X-Received: by 2002:ac8:464d:: with SMTP id f13mr72080qto.239.1573604491964;
        Tue, 12 Nov 2019 16:21:31 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:e3d4::1])
        by smtp.gmail.com with ESMTPSA id o1sm289233qtb.82.2019.11.12.16.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 16:21:31 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 7FEDEC4B29; Tue, 12 Nov 2019 21:21:28 -0300 (-03)
Date:   Tue, 12 Nov 2019 21:21:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [net-next 8/8] net/mlx5: Add vf ACL access via tc flower
Message-ID: <20191113002128.GA3419@localhost.localdomain>
References: <20191112171313.7049-1-saeedm@mellanox.com>
 <20191112171313.7049-9-saeedm@mellanox.com>
 <20191112154124.4f0f38f9@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112154124.4f0f38f9@cakuba>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 03:41:24PM -0800, Jakub Kicinski wrote:
> On Tue, 12 Nov 2019 17:13:53 +0000, Saeed Mahameed wrote:
> > From: Ariel Levkovich <lariel@mellanox.com>
> > 
> > Implementing vf ACL access via tc flower api to allow
> > admins configure the allowed vlan ids on a vf interface.
> > 
> > To add a vlan id to a vf's ingress/egress ACL table while
> > in legacy sriov mode, the implementation intercepts tc flows
> > created on the pf device where the flower matching keys include
> > the vf's mac address as the src_mac (eswitch ingress) or the
> > dst_mac (eswitch egress) while the action is accept.
> > 
> > In such cases, the mlx5 driver interpets these flows as adding
> > a vlan id to the vf's ingress/egress ACL table and updates
> > the rules in that table using eswitch ACL configuration api
> > that is introduced in a previous patch.
> 
> Nack, the magic interpretation of rules installed on the PF is a no go.

+1
