Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC6548DDB9
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237553AbiAMSe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:34:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:24582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230151AbiAMSe5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 13:34:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642098897; x=1673634897;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=9o7pEOgu6dMqwzZKSrEBIFDJMvUlLjZmpMjg2qRJLCY=;
  b=WTNjWjA3GfO7bqAcxds56kreTq6Vvrrf2s4t7f2MW1HysNUwHaOkfnqQ
   bgfn7MTq4MjSuJlyu5BkZyzxdvIAm1txwBoqjsVyW+8uog4lvhUt3KGaM
   BDAZ834FvemooHlGD9C2xcZRAY5Ev7e8TVfg7dn+vzwDQD/Yb+dbT2RF1
   mEjxUcMCtA269ihMLa3/VjTlXyhGYE3FFqbbO0Uy8tT7oqs+tEmDB65Bq
   hr3Rzif0p52f2QC8PwCs0CGC+6Q5DsYcGiTa+6F09iUsgvwg36AJGwptg
   Ef2Kqi9quXFBzr5rYKsCSGN84T+MbF22+kiFccm8zE3VF+VWDvTpqu+a/
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268445399"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="268445399"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 10:31:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="529779517"
Received: from karls-mobl1.ger.corp.intel.com ([10.252.45.63])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 10:31:25 -0800
Date:   Thu, 13 Jan 2022 20:31:19 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <61183e27-e83a-81b2-5f86-cedb39a50382@linux.intel.com>
Message-ID: <27cfde-5885-73d-962d-677e3d3a09f@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-2-ricardo.martinez@linux.intel.com> <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com> <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com> <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
 <b0cb18b-dc7b-9241-b21a-850d055d86@linux.intel.com> <Yd7/se+LD1c1wiBA@smile.fi.intel.com> <b638aa4-5a1c-e6ad-5a85-d4c3298c4daf@linux.intel.com> <2fd0756d-9ca1-b124-ed18-5ab0bda4c91f@linux.intel.com> <d9abec0-47c1-b67f-cb5a-d9e7418642c6@linux.intel.com>
 <61183e27-e83a-81b2-5f86-cedb39a50382@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-773423940-1642084426=:1629"
Content-ID: <1b8fd222-5eb0-7be3-b8b8-79e51ff82259@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-773423940-1642084426=:1629
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <f8c1d072-2d15-e39b-08e-719e44716e5f@linux.intel.com>

On Wed, 12 Jan 2022, Martinez, Ricardo wrote:

> 
> On 1/12/2022 11:24 AM, Ilpo Järvinen wrote:
> > On Wed, 12 Jan 2022, Martinez, Ricardo wrote:
> > 
> > > On 1/12/2022 10:16 AM, Ilpo Järvinen wrote:
> > > > On Wed, 12 Jan 2022, Andy Shevchenko wrote:
> > > > 
> > > > > On Wed, Jan 12, 2022 at 04:24:52PM +0200, Ilpo Järvinen wrote:
> > > > > > On Wed, 12 Jan 2022, Andy Shevchenko wrote:
> > > > > > > On Tue, Jan 11, 2022 at 08:55:58PM -0800, Martinez, Ricardo wrote:
> > > > > > > > On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
> > > > > > > > > On Mon, 6 Dec 2021, Ricardo Martinez wrote:
> > > > > > > > > > +	if (req->entry.next == &ring->gpd_ring)
> > > > > > > > > > +		return list_first_entry(&ring->gpd_ring,
> > > > > > > > > > struct
> > > > > > > > > > cldma_request, entry);
> > > > > > > > > > +
> > > > > > > > > > +	return list_next_entry(req, entry);
> > > > > > > ...
> > > > > > > 
> > > > > > > > > > +	if (req->entry.prev == &ring->gpd_ring)
> > > > > > > > > > +		return list_last_entry(&ring->gpd_ring, struct
> > > > > > > > > > cldma_request, entry);
> > > > > > > > > > +
> > > > > > > > > > +	return list_prev_entry(req, entry);
> > > > > > > ...
> > > > > > > 
> > > > > > > > > Wouldn't these two seems generic enough to warrant adding
> > > > > > > > > something like
> > > > > > > > > list_next/prev_entry_circular(...) to list.h?
> > > > > > > > Agree, in the upcoming version I'm planning to include something
> > > > > > > > like this
> > > > > > > > to list.h as suggested:
> > > > > > > I think you mean for next and prev, i.o.w. two helpers, correct?
> > > > > > > 
> > > > > > > > #define list_next_entry_circular(pos, ptr, member) \
> > > > One thing I missed earlier, the sigrature should instead of ptr have
> > > > head:
> > > > #define list_next_entry_circular(pos, head, member)
> > > > 
> > > > > > > >       ((pos)->member.next == (ptr) ? \
> > > > > > > I believe this is list_entry_is_head().
> > > > > > It takes .next so it's not the same as list_entry_is_head() and
> > > > > > list_entry_is_last() doesn't exist.
> > > > > But we have list_last_entry(). So, what about
> > > > > 
> > > > > list_last_entry() == pos ? first : next;
> > > > > 
> > > > > and counterpart
> > > > > 
> > > > > list_first_entry() == pos ? last : prev;
> > > > > 
> > > > > ?
> > > > Yes, although now that I think it more, using them implies the head
> > > > element has to be always accessed. It might be marginally cache
> > > > friendlier
> > > > to use list_entry_is_head you originally suggested but get the next
> > > > entry
> > > > first:
> > > > ({
> > > > 	typeof(pos) next__ = list_next_entry(pos, member); \
> > > > 	!list_entry_is_head(next__, head, member) ? next__ :
> > > > list_next_entry(next__, member);
> > > > })
> > > > (This was written directly to email, entirely untested).
> > > > 
> > > > Here, the head element would only get accessed when we really need to
> > > > walk
> > > > through it.
> > > I'm not sure if list_next_entry() will work for the last element, what
> > > about
> > > using list_is_last()?
> > Why wouldn't it? E.g., list_for_each_entry() does it for the last entry
> > before terminating the for loop.
> 
> I wasn't sure about using container_of() on the head of the list, but I see
> that it is not a problem.
> 
> Would that still be preferred over the list_is_last() approach?

I think list_is_last() is fine if that's what you want to use.
...I missed earlier the fact that you were referring to something else 
than list_entry_is_last thanks to these n similarly named functions :-).

-- 
 i.
--8323329-773423940-1642084426=:1629--
