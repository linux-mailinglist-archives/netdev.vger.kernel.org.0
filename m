Return-Path: <netdev+bounces-1211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FF56FCA8A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:50:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFC3B2812E1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A344318008;
	Tue,  9 May 2023 15:50:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353917FEC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24458C433D2;
	Tue,  9 May 2023 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683647423;
	bh=YPyqLi1JvH6K25uteIFbBlxtDAhKM2gup9Rq6JqaMYI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dgXrHBJ8BzFgSVJvpXADLxrii1QMdk3TMV9xXbUFlp6Zkq8lTggCE7PASJr4ml++Z
	 iHPzmBbyCF7UPgA6bQXrCLAvb8nVCic9hdkpwOMYVvwGaFZzInWlKfHcgU4OIWd7B9
	 amAbVw3DIzUpCE8yC0CctitE3lDhq0R+QBQ6btNP1G89RiwgJCetMhJHP3kx14etBH
	 xcqu4qVx5WAEjNKWmhuR8gPjWQoUy/oNnHRVXqB/AAO4beSvVsmRbRA9Ss0aNngGe0
	 I54H5mnAe0fQNSIElQ6Y5Vj5vl4UuQv6KFjJNGjOFQExV67NskLJwcc9TIT9OWWVnZ
	 rVXmnIcGXhMfw==
Date: Tue, 9 May 2023 08:50:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Sokolowski, Jan" <jan.sokolowski@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jiri Pirko
 <jiri@resnulli.us>
Subject: Re: As usage of ethtool private flags is deprecated, what should we
 use from now on?
Message-ID: <20230509085021.3382222f@kernel.org>
In-Reply-To: <PH7PR11MB58196E41B57C8FFD30108B9399769@PH7PR11MB5819.namprd11.prod.outlook.com>
References: <20230310145100.1984-1-jan.sokolowski@intel.com>
	<20230310145100.1984-2-jan.sokolowski@intel.com>
	<99823d11-4c46-d105-aaa5-2d5da113627d@intel.com>
	<PH7PR11MB58196E41B57C8FFD30108B9399769@PH7PR11MB5819.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 May 2023 11:15:57 +0000 Sokolowski, Jan wrote:
> So, as recently I've been trying to upstream a patch that would
> introduce a new private flag to i40e driver, I've received a note
> that, according to this reply from Jakub Kicinski
> (https://lore.kernel.org/netdev/20230207215643.43f76bdd@kernel.org/),
> the use of private flags is deprecated and is something that will not
> be accepted by upstream anymore. 

It has little to do with ethtool private flags being deprecated 
and a lot to do with how you were trying to use them. Andrew 
explains it well.

Maybe we should have called them "my device is weird flags", 
so people don't think they are "do whatever you want" flags :(

