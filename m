Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7730CDF152
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfJUP2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:28:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfJUP2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 11:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+2DksjGWlt2G5ntYtGjDp/r2N7PiPI/eGokRa4aOIEM=; b=LTHtk2YiuvJRqxP8DkcVaoAmP5
        4uPXm8SzqvRZBb7VN3coETrfszB5Mz5NJLxnbCMTA5rhKB7owPTVXcX2sHabJ4IudjzPg6HC0Ll/5
        i8QyPGUVJa65U77QbFuTtfRWHU5M2m7bvnRK3v8xmax5nmgNskqk2G8FX6ypWJ1HLVUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMZbY-00059z-V5; Mon, 21 Oct 2019 17:28:20 +0200
Date:   Mon, 21 Oct 2019 17:28:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
Message-ID: <20191021152820.GE17002@lunn.ch>
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 09:20:07AM -0600, David Ahern wrote:
> On 10/21/19 8:26 AM, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@mellanox.com>
> > 
> > Currently, the name format is not required by the code, however it is
> > required during patch review. All params added until now are in-lined
> > with the following format:
> > 1) lowercase characters, digits and underscored are allowed
> > 2) underscore is neither at the beginning nor at the end and
> >    there is no more than one in a row.
> > 
> > Add checker to the code to require this format from drivers and warn if
> > they don't follow. This applies to params, resources, reporters,
> > traps, trap groups, dpipe tables and dpipe fields.
> > 
> 
> This seems random and without any real cause. There is no reason to
> exclude dash and uppercase for example in the names.

Hi David

The commit message is out of date. Upper case is now allowed.

    Andrew
