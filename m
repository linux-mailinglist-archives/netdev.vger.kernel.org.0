Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029652316C0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgG2AaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:30:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44211 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730536AbgG2AaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:30:22 -0400
Received: from static-50-53-54-182.bvtn.or.frontiernet.net ([50.53.54.182] helo=[192.168.192.153])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <john.johansen@canonical.com>)
        id 1k0Zz5-0003r6-Mk; Wed, 29 Jul 2020 00:30:15 +0000
Subject: Re: [PATCH v19 06/23] LSM: Use lsmblob in security_secctx_to_secid
To:     Casey Schaufler <casey@schaufler-ca.com>,
        casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     linux-audit@redhat.com, keescook@chromium.org,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org
References: <20200724203226.16374-1-casey@schaufler-ca.com>
 <20200724203226.16374-7-casey@schaufler-ca.com>
 <bebdacdf-2ecb-8e07-1b0e-6e6bfb5960d0@canonical.com>
 <8dd6f4e0-07f0-333e-0663-0bc0889cccf2@schaufler-ca.com>
From:   John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; prefer-encrypt=mutual; keydata=
 LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkU1bXJQb0JFQURB
 azE5UHNnVmdCS2tJbW1SMmlzUFE2bzdLSmhUVEtqSmR3VmJrV1NuTm4rbzZVcDVrCm5LUDFm
 NDlFQlFsY2VXZzF5cC9Od2JSOGFkK2VTRU8vdW1hL0srUHFXdkJwdEtDOVNXRDk3Rkc0dUI0
 L2Nhb20KTEVVOTdzTFFNdG52R1dkeHJ4VlJHTTRhbnpXWU1neno1VFptSWlWVFo0M091NVZw
 YVMxVnoxWlN4UDNoL3hLTgpaci9UY1c1V1FhaTh1M1BXVm5ia2poU1pQSHYxQmdoTjY5cXhF
 UG9tckpCbTFnbXR4M1ppVm1GWGx1d1RtVGdKCk9rcEZvbDduYkowaWxuWUhyQTdTWDNDdFIx
 dXBlVXBNYS9XSWFuVk85NldkVGpISElhNDNmYmhtUXViZTR0eFMKM0ZjUUxPSlZxUXN4NmxF
 OUI3cUFwcG05aFExMHFQV3dkZlB5LyswVzZBV3ROdTVBU2lHVkNJbld6bDJIQnFZZAovWmxs
 OTN6VXErTklvQ244c0RBTTlpSCt3dGFHRGNKeXdJR0luK2VkS050SzcyQU1nQ2hUZy9qMVpv
 V0g2WmVXClBqdVVmdWJWelp0bzFGTW9HSi9TRjRNbWRRRzFpUU50ZjRzRlpiRWdYdXk5Y0dp
 MmJvbUYwenZ5QkpTQU5weGwKS05CRFlLek42S3owOUhVQWtqbEZNTmdvbUwvY2pxZ0FCdEF4
 NTlMK2RWSVpmYUYyODFwSWNVWnp3dmg1K0pvRwplT1c1dUJTTWJFN0wzOG5zem9veWtJSjVY
 ckFjaGtKeE5mejdrK0ZuUWVLRWtOekVkMkxXYzNRRjRCUVpZUlQ2ClBISGdhM1JneWtXNSsx
 d1RNcUpJTGRtdGFQYlhyRjNGdm5WMExSUGN2NHhLeDdCM2ZHbTd5Z2Rvb3dBUkFRQUIKdEIx
 S2IyaHVJRXB2YUdGdWMyVnVJRHhxYjJodVFHcHFiWGd1Ym1WMFBva0NPZ1FUQVFvQUpBSWJB
 d1VMQ1FnSApBd1VWQ2drSUN3VVdBZ01CQUFJZUFRSVhnQVVDVG8wWVZ3SVpBUUFLQ1JBRkx6
 WndHTlhEMkx4SkQvOVRKWkNwCndsbmNUZ1llcmFFTWVEZmtXdjhjMUlzTTFqMEFtRTRWdEwr
 ZkU3ODBaVlA5Z2tqZ2tkWVN4dDdlY0VUUFRLTWEKWlNpc3JsMVJ3cVUwb29nWGRYUVNweHJH
 SDAxaWN1LzJuMGpjWVNxWUtnZ1B4eTc4QkdzMkxacTRYUGZKVFptSApaR25YR3EvZURyL21T
 bmowYWF2QkptTVo2amJpUHo2eUh0QllQWjlmZG84YnRjendQNDFZZVdvSXUyNi84SUk2CmYw
 WG0zVkM1b0FhOHY3UmQrUldaYThUTXdsaHpIRXh4ZWwzanRJN0l6ek9zbm1FOS84RG0wQVJE
 NWlUTENYd1IKMWN3SS9KOUJGL1MxWHY4UE4xaHVUM0l0Q05kYXRncDh6cW9Ka2dQVmptdnlM
 NjRRM2ZFa1liZkhPV3NhYmE5LwprQVZ0Qk56OVJURmg3SUhEZkVDVmFUb3VqQmQ3QnRQcXIr
 cUlqV0ZhZEpEM0k1ZUxDVkp2VnJyb2xyQ0FUbEZ0Ck4zWWtRczZKbjFBaUlWSVUzYkhSOEdq
 ZXZnejVMbDZTQ0dIZ1Jya3lScG5TWWFVL3VMZ24zN042QVl4aS9RQUwKK2J5M0N5RUZManpX
 QUV2eVE4YnEzSXVjbjdKRWJoUy9KLy9kVXFMb2VVZjh0c0dpMDB6bXJJVFpZZUZZQVJoUQpN
 dHNmaXpJclZEdHoxaVBmL1pNcDVnUkJuaXlqcFhuMTMxY20zTTNndjZIclFzQUdubjhBSnJ1
 OEdEaTVYSllJCmNvLzEreC9xRWlOMm5DbGFBT3BiaHpOMmVVdlBEWTVXMHEzYkEvWnAybWZH
 NTJ2YlJJK3RRMEJyMUhkL3ZzbnQKVUhPOTAzbU1aZXAyTnpOM0JaNXFFdlB2RzRyVzVacTJE
 cHliV2JRclNtOW9iaUJLYjJoaGJuTmxiaUE4YW05bwpiaTVxYjJoaGJuTmxia0JqWVc1dmJt
 bGpZV3d1WTI5dFBva0NOd1FUQVFvQUlRVUNUbzBYV2dJYkF3VUxDUWdICkF3VVZDZ2tJQ3dV
 V0FnTUJBQUllQVFJWGdBQUtDUkFGTHpad0dOWEQySXRNRC85anliYzg3ZE00dUFIazZ5Tk0K
 TjBZL0JGbW10VFdWc09CaHFPbm9iNGkzOEJyRE8yQzFoUUNQQ1FlNExMczEvNHB0ZW92UXQ4
 QjJGeXJQVmp3Zwo3alpUSE5LNzRyNmxDQ1Z4eDN5dTFCN1U5UG80VlRrY3NsVmIxL3FtV3V4
 OFhXY040eXZrVHFsTCtHeHB5Sm45CjlaWmZmWEpjNk9oNlRtT2ZiS0d2TXV1djVhclNJQTNK
 SEZMZjlhTHZadEExaXNKVXI3cFM5YXBnOXVUVUdVcDcKd2ZWMFdUNlQzZUczbXRVVTJ1cDVK
 VjQ4NTBMMDVqSFM2dVdpZS9ZK3lmSk9iaXlyeE4vNlpxVzVHb25oTEJxLwptc3pjVjV2QlQz
 QkRWZTNSdkY2WGRNOU9oUG4xK1k4MXg1NCt2UTExM044aUx3RjdHR2ExNFp5SVZBTlpEMEkw
 CkhqUnZhMmsvUnFJUlR6S3l1UEg1cGtsY0tIVlBFRk1tT3pNVCtGT294Tmp2Uys3K3dHMktN
 RFlFbUhQcjFQSkIKWlNaZUh6SzE5dGZhbFBNcHBGeGkrc3lZTGFnTjBtQjdKSFF3WTdjclV1
 T0RoeWNxNjBZVnoxdGFFeWd1M1l2MgoyL0kxRUNHSHZLSEc2d2M5MG80M0MvZWxIRUNYbkVo
 N3RLcGxEY3BJQytPQ21NeEtIaFI0NitYY1p2Z3c0RGdiCjdjYTgzZVFSM0NHODlMdlFwVzJM
 TEtFRUJEajdoWmhrTGJra1BSWm0zdzhKWTQ0YXc4VnRneFdkblNFTUNMeEwKSU9OaDZ1Wjcv
 L0RZVnRjSWFNSllrZWJhWnRHZENwMElnVVpiMjQvVmR2WkNZYk82MkhrLzNWbzFuWHdIVUVz
 Mwo2RC92MWJUMFJaRmk2OUxnc0NjT2N4NGdZTGtDRFFST1pxejZBUkFBb3F3NmtrQmhXeU0x
 ZnZnYW1BVmplWjZuCktFZm5SV2JrQzk0TDFFc0pMdXAzV2IyWDBBQk5PSFNrYlNENHBBdUMy
 dEtGL0VHQnQ1Q1A3UWRWS1JHY1F6QWQKNmIyYzFJZHk5Ukx3Nnc0Z2krbm4vZDFQbTFra1lo
 a1NpNXpXYUlnMG01UlFVaytFbDh6a2Y1dGNFLzFOMFo1TwpLMkpoandGdTViWDBhMGw0Y0ZH
 V1ZRRWNpVk1ES1J0eE1qRXRrM1N4RmFsbTZaZFEycHAyODIyY2xucTR6WjltCld1MWQyd2F4
 aXorYjVJYTR3ZURZYTduNDFVUmNCRVViSkFnbmljSmtKdENUd3lJeElXMktuVnlPcmp2a1F6
 SUIKdmFQMEZkUDJ2dlpvUE1kbENJek9sSWtQTGd4RTBJV3VlVFhlQkpoTnMwMXBiOGJMcW1U
 SU1sdTRMdkJFTEEvdgplaWFqajVzOHk1NDJIL2FIc2ZCZjRNUVVoSHhPL0JaVjdoMDZLU1Vm
 SWFZN09nQWdLdUdOQjNVaWFJVVM1K2E5CmduRU9RTER4S1J5L2E3UTF2OVMrTnZ4KzdqOGlI
 M2prUUpoeFQ2WkJoWkdSeDBna0gzVCtGMG5ORG01TmFKVXMKYXN3Z0pycUZaa1VHZDJNcm0x
 cW5Ld1hpQXQ4U0ljRU5kcTMzUjBLS0tSQzgwWGd3ajhKbjMwdlhMU0crTk8xRwpIMFVNY0F4
 TXd5L3B2azZMVTVKR2paUjczSjVVTFZoSDRNTGJEZ2dEM21QYWlHOCtmb3RUckpVUHFxaGc5
 aHlVCkVQcFlHN3NxdDc0WG43OStDRVpjakxIenlsNnZBRkUyVzBreGxMdFF0VVpVSE8zNmFm
 RnY4cUdwTzNacVB2akIKVXVhdFhGNnR2VVFDd2YzSDZYTUFFUUVBQVlrQ0h3UVlBUW9BQ1FV
 Q1RtYXMrZ0liREFBS0NSQUZMelp3R05YRAoyRC9YRC8wZGRNLzRhaTFiK1RsMWp6bkthalgz
 a0crTWVFWWVJNGY0MHZjbzNyT0xyblJHRk9jYnl5ZlZGNjlNCktlcGllNE93b0kxamNUVTBB
 RGVjbmJXbkROSHByMFNjenhCTXJvM2Juckxoc212anVuVFlJdnNzQlp0QjRhVkoKanVMSUxQ
 VWxuaEZxYTdmYlZxMFpRamJpVi9ydDJqQkVOZG05cGJKWjZHam5wWUljQWJQQ0NhL2ZmTDQv
 U1FSUwpZSFhvaEdpaVM0eTVqQlRtSzVsdGZld0xPdzAyZmtleEgrSUpGcnJHQlhEU2c2bjJT
 Z3hubisrTkYzNGZYY205CnBpYXczbUtzSUNtKzBoZE5oNGFmR1o2SVdWOFBHMnRlb29WRHA0
 ZFlpaCsreFgvWFM4ekJDYzFPOXc0bnpsUDIKZ0t6bHFTV2JoaVdwaWZSSkJGYTRXdEFlSlRk
 WFlkMzdqL0JJNFJXV2hueXc3YUFQTkdqMzN5dEdITlVmNlJvMgovanRqNHRGMXkvUUZYcWpK
 Ry93R2pwZHRSZmJ0VWpxTEhJc3ZmUE5OSnEvOTU4cDc0bmRBQ2lkbFdTSHpqK09wCjI2S3Bi
 Rm5td05PMHBzaVVzbmh2SEZ3UE8vdkFibDNSc1I1KzBSbytodnMyY0VtUXV2OXIvYkRsQ2Zw
 enAydDMKY0srcmh4VXFpc094OERaZnoxQm5rYW9DUkZidnZ2ays3TC9mb21QbnRHUGtxSmNp
 WUU4VEdIa1p3MWhPa3UrNApPb00yR0I1bkVEbGorMlRGL2pMUStFaXBYOVBrUEpZdnhmUmxD
 NmRLOFBLS2ZYOUtkZm1BSWNnSGZuVjFqU24rCjh5SDJkakJQdEtpcVcwSjY5YUlzeXg3aVYv
 MDNwYVBDakpoN1hxOXZBenlkTjVVL1VBPT0KPTZQL2IKLS0tLS1FTkQgUEdQIFBVQkxJQyBL
 RVkgQkxPQ0stLS0tLQo=
Organization: Canonical
Message-ID: <8b991f1e-ad01-879e-aa36-30e830f0e52c@canonical.com>
Date:   Tue, 28 Jul 2020 17:30:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8dd6f4e0-07f0-333e-0663-0bc0889cccf2@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 4:41 PM, Casey Schaufler wrote:
> On 7/28/2020 4:11 AM, John Johansen wrote:
>> On 7/24/20 1:32 PM, Casey Schaufler wrote:
>>> Change security_secctx_to_secid() to fill in a lsmblob instead
>>> of a u32 secid. Multiple LSMs may be able to interpret the
>>> string, and this allows for setting whichever secid is
>>> appropriate. Change security_secmark_relabel_packet() to use a
>>> lsmblob instead of a u32 secid. In some other cases there is
>>> scaffolding where interfaces have yet to be converted.
>>>
>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>> Cc: netdev@vger.kernel.org
>> one comment below, but its a nice to have so
>>
>> Reviewed-by: John Johansen <john.johansen@canonical.com>
>>
>>
>>> ---
>>>  include/linux/security.h          | 30 +++++++++++++++++++++++----
>>>  include/net/scm.h                 |  7 +++++--
>>>  kernel/cred.c                     |  4 +---
>>>  net/ipv4/ip_sockglue.c            |  6 ++++--
>>>  net/netfilter/nft_meta.c          | 18 +++++++++-------
>>>  net/netfilter/xt_SECMARK.c        |  9 ++++++--
>>>  net/netlabel/netlabel_unlabeled.c | 23 +++++++++++++--------
>>>  security/security.c               | 34 ++++++++++++++++++++++++++-----
>>>  8 files changed, 98 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/include/linux/security.h b/include/linux/security.h
>>> index d81e8886d799..98176faaaba5 100644
>>> --- a/include/linux/security.h
>>> +++ b/include/linux/security.h
>>> @@ -189,6 +189,27 @@ static inline bool lsmblob_equal(struct lsmblob *bloba, struct lsmblob *blobb)
>>>  	return !memcmp(bloba, blobb, sizeof(*bloba));
>>>  }
>>>  
>>> +/**
>>> + * lsmblob_value - find the first non-zero value in an lsmblob structure.
>>> + * @blob: Pointer to the data
>>> + *
>>> + * This needs to be used with extreme caution, as the cases where
>>> + * it is appropriate are rare.
>>> + *
>>> + * Return the first secid value set in the lsmblob.
>>> + * There should only be one.
>> It would be really nice if we could have an LSM debug config, that would
>> do things like checking there is indeed only one value when this fn
>> is called.
> 
> I can't see a CONFIG_LSM_DEBUG for this alone, but if you have
> other places you'd like to see it I'm open to it.
> 

yeah there are a few other places, this really isn't a requirement
just a thought while I was going through these again.

I will have to spend some time chasing them down. Maybe even
cobble together a patch

